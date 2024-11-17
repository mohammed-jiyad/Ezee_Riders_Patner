import 'package:bikeapp/Registration/AddBankAccount.dart';
import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class IdentityVerificationScreen extends StatelessWidget {
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
              UploadSection(title: 'Upload Front, Browse'),
              SizedBox(height: 10),
              UploadSection(title: 'Upload Back, Browse'),
              SizedBox(height: 20),
              Text('PAN Card Images',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              SizedBox(height: 10),
              UploadSection(title: 'Upload Front, Browse'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
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
                    style: TextStyle(fontSize: 16,color: Colors.white),
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