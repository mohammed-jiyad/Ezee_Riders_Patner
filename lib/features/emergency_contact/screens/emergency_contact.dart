import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uig/features/emergency_contact/screens/add_contact.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  List<Map<String, String>> _savedContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  // 🔹 Load contacts from SharedPreferences safely
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedContacts = prefs.getString('emergency_contacts');

    if (savedContacts != null) {
      List<dynamic> decodedList = jsonDecode(savedContacts);
      List<Map<String, String>> contacts = decodedList.map((item) {
        return {
          'name': item['name'].toString(),
          'phone': item['phone'].toString(),
        };
      }).toList();

      setState(() {
        _savedContacts = contacts;
      });
    }
  }

  // 🔹 Navigate to AddContact and refresh the list on return
  Future<void> _navigateToAddContacts() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddContact()),
    );

    if (result == true) {
      await _loadContacts(); // Refresh contacts after returning
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
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "Emergency Contacts",
          style: AppTextStyles.baseStyle
              .copyWith(fontWeight: FontWeight.w600, fontSize: 18.72),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency contact",
                  style: AppTextStyles.baseStyle
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 18.72),
                ),
                SizedBox(height: ResponsiveSize.height(context, 4)),
                Text(
                  "Keep your friends and family in your emergency contact",
                  style: AppTextStyles.smalltitle,
                ),
              ],
            ),
          ),

          // 🔹 "Add Emergency Contact" Option (Always Visible)
          InkWell(
            onTap: _navigateToAddContacts,
            child: ListTile(
              leading: const Icon(Icons.add, size: 23),
              title: Text(
                "Add emergency contact",
                style: AppTextStyles.baseStyle2.copyWith(color: AppColors.newtextColor),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 11),
            ),
          ),

          // 🔹 Display Saved Contacts
          Expanded(
            child: _savedContacts.isEmpty
                ? Center(
              child: Text(
                "No emergency contacts added",
                style: AppTextStyles.baseStyle2.copyWith(
                  color: AppColors.greytextColor,
                ),
              ),
            )
                : ListView.builder(
              itemCount: _savedContacts.length,
              itemBuilder: (context, index) {
                final contact = _savedContacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    child: Text(
                      contact['name']!.isNotEmpty ? contact['name']![0] : '?',
                      style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.newtextColor,
                      ),
                    ),
                  ),
                  title: Text(
                    contact['name']!,
                    style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.newtextColor,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    contact['phone']!,
                    style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.greytextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  trailing: InkWell(
                    onTap: (){
                      makePhoneCall(contact['phone'].toString());
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
