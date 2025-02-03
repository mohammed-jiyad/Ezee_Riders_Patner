import 'Add_BankAccount.dart';
import 'Driving_License_Screen.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart'as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uig/utils/serverlink.dart';
class IdentityVerificationScreen extends StatefulWidget{
  @override
  State<IdentityVerificationScreen> createState()=> _IdentityVerificationScreen();

}
class _IdentityVerificationScreen extends State<IdentityVerificationScreen> {
  String? phone_number;
  void initState() {
    super.initState();
    _getPhoneNumber(); // Ensure phone number is fetched
  }
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number: $phone_number'); // Print for debugging
  }
  Future<void> _updateProfileInDatabase() async {
    final url = '${server.link}/addFieldToUser'; // Replace with your backend URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phonenumber': phone_number,
        'userData': {

          'Identitysubmit':true,
        },
      }),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      // Navigate to the next screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => IdentityVerificationScreen()),
      );
    } else {
      print("Failed to update profile. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving account: ${response.body}")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Step 5/6'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Identity Verification',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Aadhaar Card Images',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              SizedBox(height: 10),
              UploadSection(title: 'Aadhaar Upload Front'),
              SizedBox(height: 10),
              UploadSection(title: 'Aadhaar Upload Back'),
              SizedBox(height: 20),
              Text('PAN Card Images',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              SizedBox(height: 10),
              UploadSection(title: 'Pan Card Upload Front'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    await _updateProfileInDatabase();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddBankAccountScreen()));
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
                    style: TextStyle(fontSize: 16,color: Colors.white),softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}