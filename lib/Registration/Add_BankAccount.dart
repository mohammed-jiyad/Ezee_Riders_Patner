import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Documents_Submit.dart';

class AddBankAccountScreen extends StatefulWidget {
  @override
  _AddBankAccountScreenState createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reEnterAccountNumberController = TextEditingController();

  String? phone_number;

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }

  @override
  void dispose() {
    _accountHolderNameController.dispose();
    _ifscCodeController.dispose();
    _accountNumberController.dispose();
    _reEnterAccountNumberController.dispose();
    super.dispose();
  }

  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    print('Retrieved phone number: $phone_number'); // Debugging
  }

  Future<void> _updateProfileInDatabase() async {
    final url = 'http://10.0.2.2:3000/addFieldToUser';

    // Collect data from text fields
    final accountHolderName = _accountHolderNameController.text.trim();
    final ifscCode = _ifscCodeController.text.trim();
    final accountNumber = _accountNumberController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phonenumber': phone_number,
          'userData': {
            'bankaccsubmit': true,
            'accountHolderName': accountHolderName,
            'ifscCode': ifscCode,
            'accountNumber': accountNumber,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully!");
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DocumentsSubmittedPage1()),
        );
      } else {
        print("Failed to update profile. Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving account: ${response.body}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Step 6/6', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Bank Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Name of the Account Holder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _accountHolderNameController,
                decoration: InputDecoration(
                  hintText: 'Name of Account Holder',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account holder\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Enter IFSC Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _ifscCodeController,
                decoration: InputDecoration(
                  hintText: 'IFSC',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Enter Account Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  hintText: 'Account Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Confirm Account Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _reEnterAccountNumberController,
                decoration: InputDecoration(
                  hintText: 'Re-enter Account Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != _accountNumberController.text) {
                    return 'Account numbers do not match';
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfileInDatabase();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
