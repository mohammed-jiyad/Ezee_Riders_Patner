import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/explore/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:socket_io_client/socket_io_client.dart'as IO;
import 'package:uig/Backend/socket.dart';
import 'package:uig/utils/responsive_size.dart'; // Import the ResponsiveSize class
import 'package:shared_preferences/shared_preferences.dart';
class Message {
  final String text;
  final DateTime date;
  final bool isSentbyme;

  Message({
    required this.text,
    required this.date,
    required this.isSentbyme,
  });

  // Deserialize JSON into Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] ?? 'Unknown message', // Default value for text
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(), // Handle invalid or null date
      isSentbyme: false, // Default to false if missing
    );
  }

  // Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date.toIso8601String(),
      'isSentbyme': isSentbyme,
    };
  }
}
class MessageScreen extends StatefulWidget {
  final List<Message>? initialMessages;
  const MessageScreen({super.key,required this.initialMessages});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final IO.Socket socket = SocketService().getSocket();
  List<Message> messages=[];
  final List<String> predefinedMessages = ["I've Arrived", "On my way", "Stuck in traffic"];
  String? UserName;
  void initState() {
    super.initState();
    sockets();
    if (widget.initialMessages != null) {
      messages.addAll(widget.initialMessages!);
    }
  }

  Future<void> sockets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserName = prefs.getString('UserName');
    });
    UserName = prefs.getString('UserName');

    // Handle connection event
    socket.on('connect', (_) {
      print('Connected to server');
    });

    socket.on('usermessage', (data) async {
      print("Received message: $data");
      print("message ${data['message']}");
      try {
        if (data != null && data is Map<String, dynamic>) {
          setState(() {
            messages.add(Message.fromJson(data['message']));
          });
        } else {
          print("Invalid message format: $data");
        }
      } catch (e) {
        print("Error parsing message: $e");
      }
    });
    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messages=[];
  }
  void _sendMessage(String messageText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? UserId = prefs.getString('UserSocket');
    if (_controller.text.trim().isNotEmpty) {
      final message = Message(
        text: _controller.text.trim(),
        date: DateTime.now(),
        isSentbyme: true,
      );
      socket.emit('messagebydriver', {
        'driverId':socket.id,
        'userId':UserId,
        'message':message.toJson()
      });
      setState(() {
        messages.add(message);

      });

      _controller.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1C1B1F)),
        ),
        title: Text("$UserName", style: AppTextStyles.baseStyle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Chat", style: AppTextStyles.smalltitle),
          ),
          Expanded(
            child: GroupedListView<Message, DateTime>(
              elements: messages,
              groupBy: (message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              groupHeaderBuilder: (Message message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "${message.date.year}-${message.date.month}-${message.date.day}",
                  style: AppTextStyles.smalltitle.copyWith(
                    color: AppColors.messageBoxColor,
                  ),
                ),
              ),
              itemBuilder: (context, Message message) => Padding(
                padding: EdgeInsets.all(ResponsiveSize.width(context, 10)),
                child: Align(
                  alignment: message.isSentbyme
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.isSentbyme
                              ? AppColors.primaryColor
                              : AppColors.messageBoxColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.text,
                          style: AppTextStyles.smalltitle.copyWith(
                              color: AppColors.backgroundColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (message.isSentbyme)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check,
                              color: AppColors.newgreyColor,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${message.date.hour}:${message.date.minute}",
                              style: AppTextStyles.subtitle,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: predefinedMessages.map((text) {
                  return GestureDetector(
                    onTap: () => _sendMessage(text),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.messageColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        text,
                        style: AppTextStyles.smalltitle.copyWith(
                            color: AppColors.primaryColor),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 12),
              vertical: ResponsiveSize.height(context, 12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: ResponsiveSize.height(context, 42),
                    decoration: BoxDecoration(
                      color: AppColors.newColor,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.all(ResponsiveSize.height(context, 12)),
                        hintText: "Type your message",
                        hintStyle: AppTextStyles.smalltitle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.newColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => _sendMessage(_controller.text),
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
