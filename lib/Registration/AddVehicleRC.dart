import 'package:bikeapp/Registration/AddVehicle.dart';
import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:flutter/material.dart';

class VehicleRcScreen extends StatefulWidget {
  @override
  _VehicleRcScreenState createState() => _VehicleRcScreenState();
}

class _VehicleRcScreenState extends State<VehicleRcScreen> {
  bool isOwnershipDropdownOpen = false;
  bool isVehicleTypeDropdownOpen = false;

  String? selectedOwnership;
  String? selectedVehicleType;

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

  Widget _buildCustomDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? selectedValue,
    required bool isDropdownOpen,
    required Function toggleDropdown,
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
              height: 100, // Set dropdown height
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
              UploadSection(title: 'Upload'),
              // Add UploadSection or similar widget if required.
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddVehicleScreen()));
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
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
