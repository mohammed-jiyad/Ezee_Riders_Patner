import 'package:bikeapp/Registration/AddVehicleRC.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class DrivingLicenseScreen extends StatelessWidget {
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
        title: Text('Step 2/6',style: TextStyle(fontSize: 20),),
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
              UploadSection(title: 'Upload Front'),
              SizedBox(height: 16),
              UploadSection(title: 'Upload Back'),
              SizedBox(height: 16),
              Text('Enter Driving License Number',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              Container(

                color: Colors.blueGrey.shade50,
                child: Material(
                  elevation: 2,
                  color: Colors.blueGrey.shade50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Driving License Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Makes the TextField border rounded
                      ),


                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('License Plate Image',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              UploadSection(title: 'Upload'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> VehicleRcScreen()));
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
            ],
          ),
        ),
      ),
    );
  }
}

class UploadSection extends StatelessWidget {
  final String title;

  UploadSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedBorder(
          color: Colors.grey, // Color of the dotted border
          strokeWidth: 2, // Thickness of the border
          borderType: BorderType.RRect, // Rounded rectangle
          radius: Radius.circular(30), // Border radius for rounded corners
          dashPattern: [6, 3], // Defines the size of dots and gaps
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueGrey.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  blurRadius: 10, // Blur radius for the shadow
                  offset: Offset(0, 4), // Offset of the shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 40, color: Colors.indigo),
                  Text(
                    title,
                    style: TextStyle(color: Colors.black),
                  ),
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