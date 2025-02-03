
import 'Identify_Verification.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:uig/utils/serverlink.dart';
class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  String? vehicleCompany;
  String? color;
  int? year;
  String? modelNumber;

  // Dropdown visibility toggle
  bool isVehicleCompanyDropdownOpen = false;
  bool isColorDropdownOpen = false;
  bool isYearDropdownOpen = false;
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
  Future<void> _updateProfileInDatabase(String? Vehiclecompany,String? modelnumber,String? color,String? Year) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('VehicleCompany',Vehiclecompany.toString());

    final url = '${server.link}/addFieldToUser'; // Replace with your backend URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phonenumber': phone_number,
        'userData': {
          'vehiclecompany': Vehiclecompany,
          'model':modelnumber,
          'color':color,
          'Year':Year,
          'Vehiclesubmit':true,
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
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Access entered data
      print('Vehicle Company: $vehicleCompany');
      print('Model Number: $modelNumber');
      print('Color: $color');
      print('Year: $year');
      String? model = modelNumber;
      String? vehiclecompany = vehicleCompany;
      String? Colorr=color;
      String? yearr=year.toString();
      _updateProfileInDatabase(vehiclecompany,model,Colorr,yearr);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IdentityVerificationScreen(),
        ),
      );
    } else {
      print('Form validation failed');
    }
  }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              Text(
                'Select Vehicle Company',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              _buildCustomDropdown(
                label: 'Vehicle company',
                items: ['Toyota', 'Honda', 'Ford', 'BMW', 'Other'],
                onChanged: (value) {
                  setState(() {
                    vehicleCompany = value;
                    isVehicleCompanyDropdownOpen = false;
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
              Text(
                'Enter Model Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              _buildTextField(
                label: 'Model Number',
                onSaved: (value) => modelNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Select Color',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              _buildCustomDropdown(
                label: 'Color',
                items: ['Red', 'Blue', 'Black', 'White', 'Other'],
                onChanged: (value) {
                  setState(() {
                    color = value;
                    isColorDropdownOpen = false;
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
              Text(
                'Select Year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              _buildCustomDropdown(
                label: 'Year',
                items: List.generate(
                  DateTime.now().year - 2004,
                      (index) => (2005 + index).toString(),
                ),
                onChanged: (value) {
                  setState(() {
                    year = int.tryParse(value!);
                    isYearDropdownOpen = false;
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
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
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
      padding: EdgeInsets.symmetric(vertical: 16),
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
              height: 200,
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

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Container(
      color: Colors.blueGrey.shade50,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
