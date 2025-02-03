import 'Add_Vehicle.dart';
import 'Driving_License_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
class VehicleRcScreen extends StatefulWidget {
  @override
  _VehicleRcScreenState createState() => _VehicleRcScreenState();
}

class _VehicleRcScreenState extends State<VehicleRcScreen> {
  bool isOwnershipDropdownOpen = false;
  bool isVehicleTypeDropdownOpen = false;

  String? selectedOwnership;
  String? selectedVehicleType;

  TextEditingController vehicleNumberController = TextEditingController();
  String? phone_number;
  bool isOwnershipError = false;
  bool isVehicleTypeError = false;
  bool isVehicleNumberError = false;
  @override
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
  void toggleOwnershipDropdown() {
    setState(() {
      isOwnershipDropdownOpen = !isOwnershipDropdownOpen;
    });
  }

  void toggleVehicleTypeDropdown() {
    setState(() {
      isVehicleTypeDropdownOpen = !isVehicleTypeDropdownOpen;
    });
  }

  void validateAndSubmit() {
    setState(() {
      isOwnershipError = selectedOwnership == null;
      isVehicleTypeError = selectedVehicleType == null;
      isVehicleNumberError = vehicleNumberController.text.trim().isEmpty;
    });
    String vehiclenumber = vehicleNumberController.text.trim();

    if (!isOwnershipError && !isVehicleTypeError && !isVehicleNumberError) {
      // All fields are valid
      print('Ownership: $selectedOwnership');
      print('Vehicle Type: $selectedVehicleType');
      print('Vehicle Number: ${vehicleNumberController.text}');
      String? ownership = selectedOwnership;
      String? vehicletype = selectedVehicleType;
      _updateProfileInDatabase(vehiclenumber,ownership,vehicletype);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddVehicleScreen()),
      );
    } else {
      // Show a Snackbar for a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }
  Future<void> _updateProfileInDatabase(String vehiclenumber,String? ownership,String? vehicletype) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('VehicleNumber',vehiclenumber);
    await prefs.setString('VehicleType',vehicletype.toString());
    final url = '${server.link}/addFieldToUser'; // Replace with your backend URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phonenumber': phone_number,
        'userData': {
          'vehiclenumber': vehiclenumber
          ,
          'ownership':ownership,
          'vehicletype':vehicletype,
          'RCsubmit':true,
        },
      }),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      // Navigate to the next screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddVehicleScreen()),
      );
    } else {
      print("Failed to update profile. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving account: ${response.body}")),
      );
    }
  }
  Widget _buildCustomDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? selectedValue,
    required bool isDropdownOpen,
    required Function toggleDropdown,
    bool showError = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.blueGrey.shade50,
            child: GestureDetector(
              onTap: () => toggleDropdown(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: showError ? Colors.red : Colors.grey),
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
          if (showError)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Please select $label',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (isDropdownOpen)
            Container(
              height: 100,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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
              _buildCustomDropdown(
                label: 'Vehicle Ownership',
                items: ['Self', 'Rented'],
                onChanged: (value) {
                  setState(() {
                    selectedOwnership = value;
                    isOwnershipDropdownOpen = false;
                  });
                },
                selectedValue: selectedOwnership,
                isDropdownOpen: isOwnershipDropdownOpen,
                toggleDropdown: toggleOwnershipDropdown,
                showError: isOwnershipError,
              ),
              SizedBox(height: 16),
              _buildCustomDropdown(
                label: 'Vehicle Type',
                items: ['Bike', 'Scooty'],
                onChanged: (value) {
                  setState(() {
                    selectedVehicleType = value;
                    isVehicleTypeDropdownOpen = false;
                  });
                },
                selectedValue: selectedVehicleType,
                isDropdownOpen: isVehicleTypeDropdownOpen,
                toggleDropdown: toggleVehicleTypeDropdown,
                showError: isVehicleTypeError,
              ),
              SizedBox(height: 16),
              Text(
                'Vehicle Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.blueGrey.shade50,
                child: TextField(
                  controller: vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: 'Enter vehicle number',
                    border: OutlineInputBorder(),
                    errorText:
                    isVehicleNumberError ? 'Please enter vehicle number' : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Upload RC Images (optional)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              UploadSection(title: 'RC Upload Front'),
              SizedBox(height: 16),
              UploadSection(title: 'RC Upload Back'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: validateAndSubmit,
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
