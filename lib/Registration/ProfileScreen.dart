import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class ProfileFormPage extends StatefulWidget {
@override
State<ProfileFormPage> createState() => ProfileFormPageState();
}

class ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  String? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 90),
            Text('Step 1/6', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'sans-serif')),
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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Profile Info', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'sans-serif')),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(55),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'sans-serif'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildTextField('Full Name', 'Enter full name'),
              buildTextField('Email', 'Enter email', keyboardType: TextInputType.emailAddress),
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
                    });
                  }
                },
                child: AbsorbPointer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date Of Birth', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'sans-serif',color: Colors.black54.withOpacity(0.8))),
                      Material(
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: _selectedDate ?? 'DD/MM/YYYY',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'sans-serif',color: Colors.black54.withOpacity(0.8))),
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
                  Text('Male', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif')),
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
                  Text('Female', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif')),
                ],
              ),
              buildTextField('Referral Code', 'xxxxxx', isReferralCode: true),
              SizedBox(height: 3),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrivingLicenseScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4257D3),
                    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'sans-serif'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, {TextInputType keyboardType = TextInputType.text, bool isReferralCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'sans-serif',color: Colors.black54.withOpacity(0.8))),
        SizedBox(height: 8),
        Material(
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              border: Border.all(
                color: Colors.black.withOpacity(0.3),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 17, top: 7),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                ),
                keyboardType: keyboardType,
                validator: isReferralCode
                    ? null
                    : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
