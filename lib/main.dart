import 'package:bikeapp/Registration/Registration.dart';
import 'package:bikeapp/Splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = '+91'; // Default country code

  // List of country codes for dropdown
  final List<Map<String, String>> countryCodes = [
    {'name': 'India', 'code': '+91'},
    {'name': 'United States', 'code': '+1'},
    {'name': 'United Kingdom', 'code': '+44'},
    {'name': 'Canada', 'code': '+1'},
    {'name': 'Australia', 'code': '+61'},
  ];

  // Function to validate phone number
  bool isValidPhoneNumber(String phone) {
    // Simple phone number validation (length check)
    return phone.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(20),  // Ensure the image is also clipped to match the border radius
            child: Image.asset(
              'assets/logo.png',  // Replace with your logo image
              width: double.infinity  // Set a fixed height for the image
                // Ensure the image scales properly without distortion
            ),
          ),

          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Enter Your Phone Number',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "We'll send a verification code on this number.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 24),
            child: Row(
              children: [
                // Country Code Dropdown with smaller size
                Material(
                  elevation:2,
                  color: Colors.blueGrey.shade50,
                  child: Container(
                    width: 100,  // Adjust the width for a smaller dropdown
                    padding: EdgeInsets.symmetric(horizontal: 4),  // Reduced padding
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCountryCode,
                      items: countryCodes.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child: Text('${country['code']} (${country['name']})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value!;
                        });
                      },
                      underline: SizedBox(), // Remove underline
                      isExpanded: true,  // Make dropdown items take full width
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Material(
                    elevation: 2,
                    color: Colors.blueGrey.shade50,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              "Please read our terms and condition before proceeding",
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 20,left: 24,right: 24),
            child: ElevatedButton(
              onPressed: () {
                String phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty && isValidPhoneNumber(phoneNumber)) {
                  // Proceed to OTP Verification Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OTPVerificationpage(phoneNumber)),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid phone number.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent,
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Makes the button squared
                ),
              ),
              child: Text('Proceed',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),

        ],
      ),
    );
  }
}


class OTPVerificationpage extends StatefulWidget {
  final String phoneNumber;

  OTPVerificationpage(this.phoneNumber);

  @override
  _OTPVerificationpageState createState() => _OTPVerificationpageState();
}

class _OTPVerificationpageState extends State<OTPVerificationpage> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    // Dispose the focus nodes and controllers to avoid memory leaks
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _moveFocus(int currentIndex) {
    if (currentIndex < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[currentIndex + 1]);
    }
  }

  void _moveFocusBack(int currentIndex) {
    if (currentIndex > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[currentIndex - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Enter the verification code sent to you!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "We have sent you a six-digit code on your +91${widget.phoneNumber}",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      focusNode: _focusNodes[index],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // Move to next text field when a digit is entered
                          _moveFocus(index);
                        } else {
                          // Move to previous text field when backspace is pressed
                          _moveFocusBack(index);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Change number', style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Icon(Icons.refresh),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Resend Code in 30s',
                      style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ActivationStepsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Proceed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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



