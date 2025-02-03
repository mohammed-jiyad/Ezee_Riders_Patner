import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  final Set<int> _selectedContacts = {};
  final int _maxContacts = 10;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  // 🔹 Fetch Contacts with Permission
  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
      });
    }
  }

  // 🔹 Filter Contacts Based on Search Query
  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
      contact.displayName != null &&
          contact.displayName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // 🔹 Select or Deselect Contacts
  void _toggleSelection(int index) {
    setState(() {
      if (_selectedContacts.contains(index)) {
        _selectedContacts.remove(index);
      } else if (_selectedContacts.length < _maxContacts) {
        _selectedContacts.add(index);
      }
    });
  }

  // 🔹 Save Selected Contacts to SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, String>> selectedContacts = _selectedContacts.map((index) {
      final contact = _filteredContacts[index];
      return {
        'name': contact.displayName ?? 'No Name',
        'phone': contact.phones.isNotEmpty ? contact.phones.first.number ?? 'No Number' : 'No Number',
      };
    }).toList();

    // Convert list to JSON & Save
    await prefs.setString('emergency_contacts', jsonEncode(selectedContacts));
    print(jsonEncode(selectedContacts));
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
          "Emergency contact",
          style: AppTextStyles.baseStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 18.72),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Search Box
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: ResponsiveSize.height(context, 42),
              width: ResponsiveSize.width(context, 316),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.newColor),
              child: TextField(
                onChanged: _filterContacts,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 17.19,
                      color: AppColors.greytextColor,
                    ),
                    hintText: "Search",
                    hintStyle: AppTextStyles.baseStyle2.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.greytextColor)),
              ),
            ),
          ),

          // 🔹 Contacts List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                final isSelected = _selectedContacts.contains(index);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    child: Text(
                      contact.displayName != null &&
                          contact.displayName!.isNotEmpty
                          ? contact.displayName![0]
                          : '?',
                      style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.newtextColor,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.displayName ?? "No Name",
                    style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.newtextColor,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    contact.phones.isNotEmpty
                        ? contact.phones.first.number ?? "No Number"
                        : "No Number",
                    style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.greytextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      _toggleSelection(index);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    _toggleSelection(index);
                  },
                );
              },
            ),
          ),

          // 🔹 Add Contacts Button
          Container(
            height: ResponsiveSize.height(context, 48),
            width: ResponsiveSize.width(context, 330),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              onPressed: () async {
                await _saveContacts();  // Save contacts to SharedPreferences
                Navigator.pop(context, true);  // Return back and refresh
              },
              child: const Text(
                "Add",
                style: AppTextStyles.baseStyle2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
