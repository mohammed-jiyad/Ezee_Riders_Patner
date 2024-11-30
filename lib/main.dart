import 'package:uiggeeks_driver/Registration/Registration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800), // Your Figma design dimensions
      minTextAdapt: true, // Enables adaptive text resizing
      splitScreenMode: true, // Handles split-screen scenarios
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Color(0xFFFFFFFF), // Primary color of the app
            scaffoldBackgroundColor: Color(0xFFFFFFFF), // Default background color for screens
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF), // AppBar background color
              elevation: 0, // Optional: Removes shadow
              iconTheme: IconThemeData(color: Color(0xFF888888)), // AppBar icon color
              titleTextStyle: TextStyle(
                color: Color(0xFF888888),
                fontSize: 20.sp, // Use ScreenUtil for responsive font size
              ), // AppBar text style
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(), // Replace with your initial screen
        );
      },
    );
  }
}

// For JSON encoding and decoding

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = '+91'; // Default country code

  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> countryCodes = [
    {'name': 'India', 'code': '+91'},
    {'name': 'United States', 'code': '+1'},
    {'name': 'United Kingdom', 'code': '+44'},
    {'name': 'Canada', 'code': '+1'},
    {'name': 'Australia', 'code': '+61'},
  ];

  String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Please enter your phone number';
    } else if (phone.length !=10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phoneNumber); // Store phone number
  }

  Future<bool> findUser(String phoneNumber) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/findUser/$phoneNumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'] as bool;
    } else {
      throw Exception('Failed to find user');
    }
  }

  Future<void> insertUser(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/insertUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phonenumber': phoneNumber,
      'profilesubmit':false,
        'profilevalidate':false,
        'profilerejected':false,
        'DLsubmit':false,
        'DLvalidate':false,
        'DLrejected':false,
        'RCsubmit':false,
        'RCvalidate':false,
        'RCrejected':false,
        'Vehiclesubmit':false,
        'Vehiclevalidate':false,
        'Vehiclerejected':false,
        'Identitysubmit':false,
        'Identityvalidate':false,
        'Identityrejected':false,
        'bankaccsubmit':false,
        'bankaccvalidate':false,
        'bankaccrejected':false,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['message']);
    } else {
      throw Exception('Failed to insert user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.grey.shade100, elevation: 0),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/logo.png', width: double.infinity),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Enter Your Phone Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("We'll send a verification code on this number.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 24),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
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
                      underline: SizedBox(),
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
              child: ElevatedButton(
                onPressed: () async {
                  String phoneNumber = phoneController.text.trim();
                  String? validationMessage = validatePhoneNumber(phoneNumber);
                  if (validationMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validationMessage)));
                  } else {
                    await savePhoneNumber('$phoneNumber');
                    bool userExists = await findUser(phoneNumber);
                    if (userExists) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTPVerificationpage('$selectedCountryCode$phoneNumber')));
                    } else {
                      await insertUser(phoneNumber);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User created")));
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTPVerificationpage('$selectedCountryCode$phoneNumber')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent, minimumSize: Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
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



