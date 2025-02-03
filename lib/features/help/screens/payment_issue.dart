import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uig/features/help/screens/tickets.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:flutter/material.dart';
class PaymentIssue extends StatefulWidget {
  final String value;
  const PaymentIssue({super.key, required this.value});

  @override
  State<PaymentIssue> createState() => _PaymentIssueState();
}

class _PaymentIssueState extends State<PaymentIssue> {
  final TextEditingController _issueController = TextEditingController();
  String? phone_number;

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }

  /// Retrieves the stored phone number from SharedPreferences
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number') ?? "Unknown"; // Handle null case
    });
    print('Retrieved phone number: $phone_number');
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  /// Launches email client with prefilled data
  Future<void> sendEmail(String body) async {
    final String recipient = "mjiyad119@gmail.com"; // Replace with a dynamic email or predefined one
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: {
        'subject': widget.value,
        'body': body,
      },
    );

    try {
      // First, check if an email app can handle the mailto URI
      if (await canLaunchUrl(emailUri)) {
        // Launch the email app if it can handle the URI
        await launchUrl(emailUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open email app.")),
        );
      }
    } catch (e) {
      // Catch any error and show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error while trying to send the email.")),
      );
      print("Error sending email: $e");
    }
  }


  /// Inserts the issue ticket into the backend server
  Future<void> insertTicket(String phoneNumber, String body) async {
    String timestamp = getIndianTimestamp();
    try {
      final response = await http.post(
        Uri.parse('${server.link}/insertticket'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phonenumber': phoneNumber,
          'body': body,
          'Title': widget.value,
          'createdAt': timestamp
        }),
      );

      if (response.statusCode == 200) {
        print("Ticket inserted successfully");
      } else {
        print("Failed to insert ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("Error inserting ticket: $e");
    }
  }

  /// Gets current timestamp in IST
  String getIndianTimestamp() {
    final now = DateTime.now();
    return now.toLocal().toString();
  }

  /// Handles issue submission
  void _submitIssue() {
    String issueText = _issueController.text.trim();
    if (issueText.isNotEmpty) {
      sendEmail(issueText);
      insertTicket(phone_number ?? "Unknown", issueText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Issue Submitted: $issueText')),
      );
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Tickets()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.blackColor,
          ),
        ),
        title: Text(
          widget.value,
          style: AppTextStyles.headline.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ResponsiveSize.height(context, 36),
                  width: ResponsiveSize.width(context, 249),
                  child: TextField(
                    controller: _issueController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.newColor,
                      hintText: "Describe the issue in a few lines",
                      hintStyle: AppTextStyles.smalltitle,
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveSize.width(context, 90),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.greenColor,
                    ),
                    onPressed: _submitIssue,
                    child: Text(
                      "Raise Ticket",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.backgroundColor,
                      ),
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
