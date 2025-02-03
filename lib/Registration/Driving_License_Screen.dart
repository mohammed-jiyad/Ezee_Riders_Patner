import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:io';
import 'Add_Vehicle_RC.dart'; // For the next screen navigation

import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
// For the next screen navigation

class DrivingLicenseScreen extends StatefulWidget {
  @override
  State<DrivingLicenseScreen> createState() => _DrivingLicenseScreen();
}

class _DrivingLicenseScreen extends State<DrivingLicenseScreen> {
  @override
  void initState() {
    super.initState();
    _getPhoneNumber(); // Ensure phone number is fetched
  }

  // Controller for the TextField
  final TextEditingController licenseNumberController = TextEditingController();
  String? phone_number;

  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('DLSubmitted',false);
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number: $phone_number'); // Print for debugging
  }
  Future<void> _updateProfileInDatabase(String licensnumber) async {
    final url = '${server.link}/addFieldToUser'; // Replace with your backend URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phonenumber': phone_number,
        'userData': {
          'licensenumber': licensnumber,
          'DLsubmit':true,
        },
      }),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      // Navigate to the next screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => VehicleRcScreen()),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Step 2/6',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driving License',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Driving License',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 16),
              UploadSection(title: 'DL Upload Front'),
              SizedBox(height: 16),
              UploadSection(title: 'DL Upload Back'),
              SizedBox(height: 16),
              Text(
                'Enter Driving License Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: Material(
                  elevation: 2,
                  color: Colors.blueGrey.shade50,
                  child: TextField(
                    controller: licenseNumberController, // Attach the controller
                    decoration: InputDecoration(
                      hintText: 'Enter Driving License Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded border
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'License Plate Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              UploadSection(title: 'Upload License Plate'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve the value from the TextField
                  String licenseNumber = licenseNumberController.text.trim();

                  if (licenseNumber.isEmpty) {
                    // Show an alert if the field is empty
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter your Driving License Number"),
                    ));
                    return;
                  } else {
                    final userData = {
                      'DL Number': licenseNumber,
                    };


                    // Ensure phone_number is not null before proceeding
                    if (phone_number != null) {
                      // You can handle the logic for saving userData here
                      // For example, saving locally or calling a backend API
                      print('Driving License Number: $licenseNumber');
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('DLSubmitted', true);
                      _updateProfileInDatabase(licenseNumber);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VehicleRcScreen()),
                      );
                    } else {
                      print("Phone number is null. Cannot proceed.");
                    }
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
                  style: TextStyle(fontSize: 16, color: Colors.white),softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadSection extends StatefulWidget {
  final String title;

  UploadSection({required this.title});

  @override
  _UploadSectionState createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  String? fileName;
  String? filepath;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }


  void pickFile() async {
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {

        PlatformFile file = result.files.first;


        if (file.size > 2 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File size exceeds 2 MB. Please select a smaller file.")),
          );
          return;
        }


        setState(() {
          fileName = file.name;
          filepath = file.path;
        });

        print('File Name: ${file.name}');
        print('File Path: ${file.path}');
        print('File Size: ${file.size} bytes');


        if (filepath != null && phoneNumber != null) {
          File fileObj = File(filepath!);
          Uint8List fileData = await fileObj.readAsBytes();


          await uploadFileToServer(phoneNumber!, fileData, file.name, widget.title);
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }


  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = prefs.getString('phone_number');
    });
    print('Retrieved phone number: $phoneNumber');
  }


  Future<void> uploadFileToServer(String phoneNumber, Uint8List fileData, String fileName, String title) async {
    try {
      var uri = Uri.parse("${server.link}/uploadFileForUser");

      var request = http.MultipartRequest('POST', uri)
        ..fields['phoneNumber'] = phoneNumber
        ..fields['uploadTitle'] = title
        ..files.add(http.MultipartFile.fromBytes('file', fileData, filename: fileName));


      var response = await request.send();

      if (response.statusCode == 200) {
        print("File uploaded successfully.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully.")));
      } else {
        print("Failed to upload file: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload file.")));
      }
    } catch (e) {
      print("Error while uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading file.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedBorder(
          color: Colors.grey,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Radius.circular(30),
          dashPattern: [6, 3],
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueGrey.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 40, color: Colors.indigo),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                          onPressed: pickFile,
                          child: Text('Browse'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  fileName != null
                      ? Text(
                    'Selected file: $fileName',
                    style: TextStyle(color: Colors.black),
                  )
                      : Text(
                    'No file selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Maximum file size 2 MB',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
