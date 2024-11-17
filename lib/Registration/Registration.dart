import 'package:bikeapp/Registration/AddBankAccount.dart';
import 'package:bikeapp/Registration/AddVehicle.dart';
import 'package:bikeapp/Registration/AddVehicleRC.dart';
import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/IdentifyVerification.dart';
import 'package:bikeapp/Registration/SelfieScreen.dart';
import 'package:flutter/material.dart';

class ActivationStepsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> steps = [
    {'title': 'Profile Info', 'isUnlocked': true,'navigate':SelfieScreen()},
    {'title': 'Driving License', 'isUnlocked': false,'navigate':DrivingLicenseScreen()},
    {'title': 'Vehicle RC', 'isUnlocked': false,'navigate':VehicleRcScreen()},
    {'title': 'Add Vehicle', 'isUnlocked': false,'navigate':AddVehicleScreen()},
    {'title': 'Identity Verification', 'isUnlocked': false,'navigate':IdentityVerificationScreen()},
    {'title': 'Bank Details', 'isUnlocked': false,'navigate':AddBankAccountScreen()},
  ];

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(left: 24,right: 24,top: 16,bottom: 16),
              child: Text(
                'Complete all the steps to activate your account',
                style: TextStyle(fontSize: 22, color: Colors.indigo,fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                return GestureDetector(
                  onTap: step['isUnlocked'] ? () {
                    // Navigate to the corresponding step form
                  } : null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), border: Border.all(  // Add this line to set the border
                        color: Colors.grey.shade300, // Set the border color (you can choose your desired color)
                        width: 2, // Set the width of the border
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
                            Text(
                              step['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: step['isUnlocked'] ? Colors.black : Colors.grey,
                              ),
                            ),
                            InkWell(

                                onTap: () {
                      if (step['isUnlocked']) {
                      // Navigate to the screen specified in step['navigate']
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => step['navigate']),
                      );
                      } else {
                      // Handle the case where the step is not unlocked (optional)

                      }
                      },
                              child: Icon(
                                step['isUnlocked'] ? Icons.arrow_forward : Icons.lock,
                                color: step['isUnlocked'] ? Colors.blue : Colors.grey,
                              ),
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









// Driving License Page




// Vehicle RC Page



// Identity Verification Page


// Add Bank Account Page

// Documents Submitted Page
class DocumentsSubmittedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child:  Image.network(
                'https://s3-alpha-sig.figma.com/img/be7b/48a5/1826d6fdc892aa501f37ac8fb16062bd?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=YB9Ggrm4jBAZ5Rp1swc24i9S8lMkJZjca2ZAiRHN9WF3GMTkh7KNwzhvra4-7SnUokt103tYYI7SisWSZzAzcBUHKMpPUH6ps~3mMSNgwA78HDM~3o0ELMK-xWvn9dhPOBCC9E4nFurcSlcWVkfubO30b0khkhLuLg8jkUJNZy8UX~HKrgzXhuT-iAspgD34hLIdMQvZD96Qr6ieIFF3B3JIbZQDok6wNlOG4UHzwPKeHA5Fpp924tYzmx1do4OZRO3CQwNBS6VhyC39QC2l2UXFMv0qf~szxEBKgg2ZJPZXU-N0nSSd5J9HcC1L5~QZ-CBrWmZulFIQcHjgqUoc4g__',
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Documents Submitted!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You will get a verification call on your registered phone number +91 123345567',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 287,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to the previous page
                },
                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.indigoAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Go back',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
