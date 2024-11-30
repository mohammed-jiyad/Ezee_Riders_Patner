import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Driving_License_Screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileFormPage extends StatefulWidget {
  @override
  State<ProfileFormPage> createState() => ProfileFormPageState();
}

class ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  String? _selectedDate;
  String _gender = 'Male';
  String? phone_number;
  bool formsaved=false;

  // Flag to track if the form has been submitted
  bool _isSubmitted = false;


  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ProfileSubmitted',false);
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    print('Retrieved phone number: $phone_number');
  }

  Future<void> _updateProfileInDatabase(String fullName, String email,
      String referralCode, String gender, String? dateOfBirth) async {
    final url = 'http://10.0.2.2:3000/addFieldToUser';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phonenumber': phone_number,
        'userData': {
          'fullname': fullName,
          'email': email,
          'referralCode': referralCode,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'profilesubmit':true,
        },
      }),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DrivingLicenseScreen()),
      );
    } else {
      print("Failed to update profile. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving account: ${response.body}")),
      );
    }
  }

  void _saveForm() async {
    await _getPhoneNumber();
    if (phone_number == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number is not available")),
      );
      return;
    }

    setState(() {
      _isSubmitted = true;  // Mark form as submitted to trigger error messages
    });

    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final referralCode = _referralCodeController.text.trim();
      final gender = _gender;
      final dateOfBirth = _selectedDate;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ProfileSubmitted', true);
      _updateProfileInDatabase(fullName, email, referralCode, gender, dateOfBirth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 90),
            Text('Step 1/6', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Profile Info',
                style: TextStyle(fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans-serif'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: CircleAvatar(
                    radius: 50.sp,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'sans-serif'),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              buildTextField('Full Name', 'Enter full name', _fullNameController),
              buildTextField('Email', 'Enter email', _emailController, keyboardType: TextInputType.emailAddress),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                      _dobController.text = _selectedDate!;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Of Birth',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 324.w,
                        height: 45.h,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _dobController.text.isEmpty && _isSubmitted? Colors.red : Colors.blueGrey.shade100, // Conditional border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextFormField(
                            controller: _dobController,
                            decoration: InputDecoration(
                              hintText: _selectedDate ?? 'DD/MM/YYYY',
                              border: InputBorder.none,
                              fillColor: Color(0xFFF7F8FB),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _dobController.text.isEmpty && _isSubmitted ? Colors.red : Color(0xFFD9D9D9), // Conditional enabled border color
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),

                            ),

                          ),
                        ),
                      ),
                      // Display the error message below the TextFormField without affecting its size
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0), // 4px gap
                        child: Text(
                          _dobController.text.isEmpty && _isSubmitted ? 'Please select your date of birth' : '',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),



              SizedBox(height: 16),
              Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    activeColor: Colors.blue,
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Male', style: TextStyle(fontSize: 16)),
                  Radio<String>(
                    activeColor: Colors.blue,
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Female', style: TextStyle(fontSize: 16)),
                ],
              ),
              buildTextField('Referral Code', 'xxxxxx', _referralCodeController, isReferralCode: true),
              SizedBox(height: 3),
              Center(
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4257D3),
                    padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool isReferralCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black54.withOpacity(0.8))),
        SizedBox(height: 8),
        SizedBox(
          width: 324.w,
          height: 60.h,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF7F8FB),
              border: InputBorder.none,
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            keyboardType: keyboardType,
            validator: isReferralCode ? null : (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
