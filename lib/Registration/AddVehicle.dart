import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/IdentifyVerification.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  String? vehicleCompany;
  String? color;
  int? year;

  // Custom dropdown visibility toggle
  bool isVehicleCompanyDropdownOpen = false;
  bool isColorDropdownOpen = false;
  bool isYearDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Step 4/6'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView( // Wrap the entire body in a scroll view
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add your vehicle',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your vehicle must be 2005 or newer.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Text('Select Vehicle Company',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            _buildCustomDropdown(
              label: 'Vehicle company',
              items: ['Toyota', 'Honda', 'Ford', 'BMW', 'Other'],
              onChanged: (value) {
                setState(() {
                  vehicleCompany = value;
                  isVehicleCompanyDropdownOpen = false; // Close dropdown after selection
                });
              },
              selectedValue: vehicleCompany,
              isDropdownOpen: isVehicleCompanyDropdownOpen,
              toggleDropdown: () {
                setState(() {
                  isVehicleCompanyDropdownOpen = !isVehicleCompanyDropdownOpen;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Enter Model Number',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            _buildTextField(
              label: 'Model Number',
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            Text('Select Color',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            _buildCustomDropdown(
              label: 'Color',
              items: ['Red', 'Blue', 'Black', 'White', 'Other'],
              onChanged: (value) {
                setState(() {
                  color = value;
                  isColorDropdownOpen = false; // Close dropdown after selection
                });
              },
              selectedValue: color,
              isDropdownOpen: isColorDropdownOpen,
              toggleDropdown: () {
                setState(() {
                  isColorDropdownOpen = !isColorDropdownOpen;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Select Year',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            _buildCustomDropdown(
              label: 'Year',
              items: List.generate(
                DateTime.now().year - 2004,
                    (index) => 2005 + index,
              ).map((e) => e.toString()).toList(),
              onChanged: (value) {
                setState(() {
                  year = int.tryParse(value!);
                  isYearDropdownOpen = false; // Close dropdown after selection
                });
              },
              selectedValue: year?.toString(),
              isDropdownOpen: isYearDropdownOpen,
              toggleDropdown: () {
                setState(() {
                  isYearDropdownOpen = !isYearDropdownOpen;
                });
              },
            ),
            SizedBox(height: 40),
            // Removed Spacer, allowing the button to stay at the bottom
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IdentityVerificationScreen()));
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? selectedValue,
    required bool isDropdownOpen,
    required Function toggleDropdown,
  }) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 16,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            color: Colors.blueGrey.shade50,
            child: GestureDetector(
              onTap: () => toggleDropdown(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedValue ?? 'Select $label',
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          if (isDropdownOpen)
            Container(
              height: 200, // Set dropdown height
              color: Colors.white,
              child: ListView(
                children: items.map((String value) {
                  return ListTile(
                    title: Text(value),
                    onTap: () {
                      onChanged(value);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required Function(String?) onChanged}) {
    return Container(
      color: Colors.blueGrey.shade50,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
