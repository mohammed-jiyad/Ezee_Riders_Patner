import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Selfie_Screen.dart';
import 'Driving_License_Screen.dart';
import 'Add_Vehicle_RC.dart';
import 'Add_Vehicle.dart';
import 'Identify_Verification.dart';
import 'Add_BankAccount.dart';

class ActivationStepsScreen extends StatefulWidget {
  @override
  State<ActivationStepsScreen> createState() => _ActivationStepsScreen();
}

class _ActivationStepsScreen extends State<ActivationStepsScreen> {
  bool profileSubmit = false;
  bool DLSubmit = false;
  bool profileValidate =false;
  bool RCSubmit = false;
  bool VehicleSubmit = false;
  bool IdentitySubmit = false;
  bool bankaccSubmit = false;
  bool DLValidate =false;
  bool RCValidate =false;
  bool VehicleValidate =false;
  bool IdentityValidate =false;
  bool bankaccValidate =false;
  bool profileRejected =false;
  bool DLRejected =false;
  bool RCRejected =false;
  bool VehicleRejected =false;
  bool IdentityRejected =false;
  bool bankaccRejected =false;

  String? phone_number;
  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }

  // Fetch phone number and user booleans
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
      fetchAndUseUserBooleans(phone_number);
    });
    print('Retrieved phone number: $phone_number');
  }

  // Get the boolean values for each step
  Future<Map<String, dynamic>?> getBooleanValues(String? phoneNumber) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/getBooleanValues/$phoneNumber'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      print("User Booleans: $data");
      return data;
    } else if (response.statusCode == 404) {
      print("User not found");
      return null;
    } else {
      throw Exception('Failed to fetch user boolean values');
    }
  }

  // Set user booleans based on the response
  void fetchAndUseUserBooleans(String? phoneNumber) async {
    final userBooleans = await getBooleanValues(phoneNumber);
    print(userBooleans);
    if (userBooleans != null) {
      setState(() {
        profileSubmit = userBooleans['profilesubmit'] ?? false;
        profileValidate = userBooleans['profilevalidate'] ?? false;
        profileRejected = userBooleans['profilerejected'] ?? false;
        DLValidate = userBooleans['DLvalidate'] ?? false;
        DLSubmit = userBooleans['DLsubmit'] ?? false;
        DLRejected = userBooleans['DLrejected'] ?? false;
        RCValidate = userBooleans['RCvalidate'] ?? false;
        RCSubmit = userBooleans['RCsubmit'] ?? false;
        RCRejected = userBooleans['RCrejected'] ?? false;
        VehicleSubmit = userBooleans['Vehiclesubmit'] ?? false;
        VehicleValidate = userBooleans['Vehiclevalidate'] ?? false;
        VehicleRejected = userBooleans['Vehiclerejected'] ?? false;
        IdentitySubmit = userBooleans['Identitysubmit'] ?? false;
        IdentityValidate = userBooleans['Identityvalidate'] ?? false;
        IdentityRejected = userBooleans['Identityrejected'] ?? false;
        bankaccSubmit = userBooleans['bankaccsubmit'] ?? false;
        bankaccValidate = userBooleans['bankaccvalidate'] ?? false;
        bankaccRejected = userBooleans['bankaccrejected'] ?? false;
      });
      print(profileValidate);
      print(profileSubmit);
      print(RCSubmit);
      print(RCValidate);
      print(RCRejected);
    } else {
      print("No data found for the provided phone number");
    }
  }

  // Generate steps with dynamic unlock status based on the first incomplete step
  List<Map<String, dynamic>> getSteps() {
    final stepsData = [
      {
        'title': 'Profile Info',
        'completed': profileSubmit,
        'navigate': SelfieScreen(),
        'status': profileSubmit & profileValidate ? 'accepted' : profileSubmit ? profileValidate ? 'accepted' : profileRejected ? 'rejected' : 'pending' : 'notsubmitted',
      },
      {
        'title': 'Driving License',
        'completed': DLSubmit,
        'navigate': DrivingLicenseScreen(),
        'status': DLSubmit & DLValidate ? 'accepted' : DLSubmit ? DLValidate ? 'accepted' : DLRejected ? 'rejected' : 'pending' : 'notsubmitted',
      },
      {
        'title': 'Vehicle RC',
        'completed': RCSubmit,
        'navigate': VehicleRcScreen(),
        'status': RCSubmit & RCValidate ? 'accepted' :( RCSubmit ? (RCValidate ? ('accepted') : (RCRejected ? 'rejected' : 'pending')) : 'notsubmitted'),
      },
      {
        'title': 'Add Vehicle',
        'completed': VehicleSubmit,
        'navigate': AddVehicleScreen(),
        'status': VehicleSubmit & VehicleValidate ? 'accepted' : VehicleSubmit ? VehicleValidate ? 'accepted' : VehicleRejected ? 'rejected' : 'pending' : 'notsubmitted',
      },
      {
        'title': 'Identity Verification',
        'completed': IdentitySubmit,
        'navigate': IdentityVerificationScreen(),
        'status': IdentitySubmit & IdentityValidate ? 'accepted' : IdentitySubmit ? IdentityValidate ? 'accepted' : IdentityRejected ? 'rejected' : 'pending' : 'notsubmitted',
      },
      {
        'title': 'Bank Details',
        'completed': bankaccSubmit,
        'navigate': AddBankAccountScreen(),
        'status': bankaccSubmit & bankaccValidate ? 'accepted' : bankaccSubmit ? bankaccValidate ? 'accepted' : bankaccRejected ? 'rejected' : 'pending' : 'notsubmitted',
      },
    ];

    int firstIncompleteIndex = stepsData.indexWhere((step) => step['completed'] == false);
    if (firstIncompleteIndex == -1) {
      firstIncompleteIndex = stepsData.length;
    }

    for (int i = 0; i < stepsData.length; i++) {
      bool completed = stepsData[i]['completed'] == true;
      stepsData[i]['isUnlocked'] = i == firstIncompleteIndex && !completed;
    }

    return stepsData;
  }

  @override
  Widget build(BuildContext context) {
    final steps = getSteps(); // Generate steps dynamically

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              child: Text(
                'Complete all the steps to activate your account',
                style: TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                String statusImage = '';

                // Check the status and set the image accordingly
                if (step['completed'] == true) {
                  if (step['status'] == 'accepted') {
                    statusImage = 'assets/Approved.png'; // Show nothing if accepted
                  } else if (step['status'] == 'rejected') {
                    statusImage = 'assets/Notverified.png';
                  } else if (step['status'] == 'pending') {
                    statusImage = 'assets/Exc.png'; // Show exclamation if pending but submitted
                  }
                  else if(step['status'] == 'notsubmitted'){
                    statusImage='';
                  }
                }

                return GestureDetector(
                  onTap: step['isUnlocked'] ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => step['navigate']),
                    );
                  } : null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                step['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: step['isUnlocked'] ? Colors.black : Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (statusImage.isNotEmpty)
                                  Image.asset(
                                    statusImage,
                                    width: 24, height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                SizedBox(width: 8),
                                Icon(
                                  step['isUnlocked'] ? Icons.arrow_forward : Icons.lock,
                                  color: step['isUnlocked'] ? Colors.blue : Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
