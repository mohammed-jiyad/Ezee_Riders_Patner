import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/serverlink.dart';
class CancelProgress extends StatefulWidget {
  const CancelProgress({super.key});

  @override
  State<CancelProgress> createState() => _CancelProgressState();
}

class _CancelProgressState extends State<CancelProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Countdown duration
    )..forward(); // Start the animation

    // Initialize the socket connection
    initializeSocket();
  }

  void initializeSocket() {
    socket = IO.io('${server.link}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to server: ${socket.id}');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  @override
  void dispose() {
    // Dispose animation controller
    _controller.dispose();




    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress countdown
          SizedBox(
            width: 36,
            height: 36,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: 1.0 - _controller.value, // Reverse countdown
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.redColor),
                  strokeWidth: 3,
                );
              },
            ),
          ),
          // Cancel button
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.redColor),
            iconSize: 16,
            onPressed: () {
              // Stop the animation
              _controller.stop();

              // Emit 'removeRideRequest' event to the server
              if (socket.connected) {
                socket.emit('removeRequest', {'driverId': socket.id});
                print("Cancel button pressed, event sent.");
              } else {
                print("Socket not connected. Unable to send event.");
              }
            },
          ),
        ],
      ),
    );
  }
}
