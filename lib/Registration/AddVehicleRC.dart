import 'package:bikeapp/Registration/AddVehicle.dart';
import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class VehicleRcScreen extends StatelessWidget {
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
        title: Text('Step 3/6'),
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
                'Vehicle RC',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Vehicle Ownership',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.blueGrey.shade50,
                child: DropdownButtonFormField<String>(
                  items: ['Self', 'Rented'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    hintText: 'Select',
                    hintStyle: TextStyle(
                      fontSize: 16,

                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  menuMaxHeight: 200,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Vehicle Type',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.blueGrey.shade50,
                child: DropdownButtonFormField<String>(
                  items: ['Bike','Scooty'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    hintText: 'Select',
                    hintStyle: TextStyle(
                      fontSize: 16,

                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Vehicle Number',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.blueGrey.shade50,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter vehicle number',
                    border: OutlineInputBorder(),

                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Upload RC Images (optional)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              UploadSection(title: 'Upload Front'),
              SizedBox(height: 16),
              UploadSection(title: 'Upload Back'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddVehicleScreen()));
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