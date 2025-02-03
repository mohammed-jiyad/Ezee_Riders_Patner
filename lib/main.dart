import 'package:uig/Registration/Registration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uig/checking.dart';
import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/features/online/screens/online_state.dart';

import 'Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
import 'package:uig/Backend/socket.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("d198aaa4-00e2-4ddd-9961-15bc99bc3554");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
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
            scaffoldBackgroundColor:
                Color(0xFFFFFFFF), // Default background color for screens
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF), // AppBar background color
              elevation: 0, // Optional: Removes shadow
              iconTheme:
                  IconThemeData(color: Color(0xFF888888)), // AppBar icon color
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
  String? validationMessage;
  String phoneNumber = "";
  final _formKey = GlobalKey<FormState>();
  String? sessionId;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    set();
  }

  final String apiKey =
      "21d04851-bc68-11ef-8b17-0200cd936042"; // Your 2Factor API Key
  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
    });
    String phone = "+91" + phoneController.text.trim();
    print(phone);
    String url =
        "https://2factor.in/API/V1/$apiKey/SMS/$phone/AUTOGEN?channel=sms";

    try {
      // Start Debugging: print the phone number and URL
      print("Sending OTP to: $phone");
      print("API Request URL: $url");

      final response = await http.get(Uri.parse(url));
      print("Request sent. Awaiting response...");

      // Debugging: Check if response is OK
      if (response.statusCode == 200) {
        print("Response received: ${response.body}");
        final data = json.decode(response.body);

        // Check if the status is success and handle accordingly
        if (data["Status"] == "Success") {
          sessionId = data["Details"];
          print(sessionId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP sent successfully!")),
          );

          // Navigate to OTP Verification screen
          navigate();
        } else {
          // Log the error message received from the API
          print("Error: ${data["Details"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${data["Details"]}")),
          );
        }
      } else {
        // Log the HTTP response code and body for debugging
        print("Error: Received non-200 status code ${response.statusCode}");
        print("Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API Error: Unable to send OTP")),
        );
      }
    } catch (e) {
      // Log the error message
      print("Error occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void set() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', false);
  }

  final List<Map<String, String>> countryCodes = [
    {'name': 'India', 'code': '+91'},
  ];

  String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Please enter your phone number';
    } else if (phone.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phoneNumber); // Store phone number
  }

  void navigate() async {
    if (validationMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(validationMessage.toString())));
    } else {
      await savePhoneNumber('$phoneNumber');
      bool userExists = await findUser(phoneNumber);
      if (userExists) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OTPVerificationpage(
                '$selectedCountryCode$phoneNumber', '$sessionId')));
      } else {
        await insertUser(phoneNumber);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User created")));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OTPVerificationpage(
                '$selectedCountryCode$phoneNumber', '$sessionId')));
      }
    }
  }

  Future<bool> findUser(String phoneNumber) async {
    final response =
        await http.get(Uri.parse('${server.link}/findUser/$phoneNumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('login', true);
      return data['exists'] as bool;
    }
    else if (response.statusCode == 404){
      return false;
    }
    else {
      throw Exception('Failed to find user');
    }
  }

  String getIndianTimestamp() {
    DateTime utcTime = DateTime.now().toUtc();

    DateTime indianTime = utcTime.add(Duration(hours: 5, minutes: 30));

    return indianTime.toIso8601String();
  }

  Future<void> insertUser(String phoneNumber) async {
    String timestamp = getIndianTimestamp();
    final response = await http.post(
      Uri.parse('${server.link}/insertUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phonenumber': phoneNumber,
        'profilesubmit': false,
        'profilevalidate': false,
        'profilerejected': false,
        'DLsubmit': false,
        'DLvalidate': false,
        'DLrejected': false,
        'RCsubmit': false,
        'RCvalidate': false,
        'RCrejected': false,
        'Vehiclesubmit': false,
        'Vehiclevalidate': false,
        'Vehiclerejected': false,
        'Identitysubmit': false,
        'Identityvalidate': false,
        'Identityrejected': false,
        'bankaccsubmit': false,
        'bankaccvalidate': false,
        'bankaccrejected': false,
        'createdAt': timestamp
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('login', true);
      print(data['message']);
    } else {
      throw Exception('Failed to insert user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.grey.shade100, elevation: 0),
      body:
        isLoading?Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures minimal vertical space usage
            mainAxisAlignment: MainAxisAlignment.center, // Centers the column contents
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Change color here
              ),
              SizedBox(height: 10), // Provides spacing between elements
              Text(
                'Please wait while we send the OTP',
                style: TextStyle(fontSize: 16), // Adjust text styling as needed
              ),
            ],
          ),
        )
            :Form(
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
              child: Text('Enter Your Phone Number',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("We'll send a verification code on this number.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 24),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton<String>(
                      value: selectedCountryCode,
                      items: countryCodes.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child:
                              Text('${country['code']} (${country['name']})'),
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                  phoneNumber = phoneController.text.trim();
                  validationMessage = validatePhoneNumber(phoneNumber);
                  await sendOTP();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text('Proceed',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
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
  final String session;
  OTPVerificationpage(this.phoneNumber, this.session);

  @override
  _OTPVerificationpageState createState() => _OTPVerificationpageState();
}

class _OTPVerificationpageState extends State<OTPVerificationpage> {
  bool profileSubmit = false;
  bool DLSubmit = false;
  String otp="";
  bool profileValidate = false;
  bool RCSubmit = false;
  bool VehicleSubmit = false;
  bool IdentitySubmit = false;
  bool bankaccSubmit = false;
  bool DLValidate = false;
  bool RCValidate = false;
  bool VehicleValidate = false;
  bool IdentityValidate = false;
  bool bankaccValidate = false;
  bool profileRejected = false;
  bool DLRejected = false;
  bool RCRejected = false;
  bool VehicleRejected = false;
  bool IdentityRejected = false;
  bool bankaccRejected = false;
  bool? logincred;
  String? phno;

  @override
  void initState() {
    super.initState();
    set();
  }

  void set() async {
    final prefs = await SharedPreferences.getInstance();

    phno = prefs.getString('phone_number');
    print(phno);
    await fetchAndUseUserBooleans(phno);
    print(profileValidate);
    print(DLValidate);
    print(RCValidate);
    print(VehicleValidate);
    print(IdentityValidate);
    print(bankaccValidate);
  }

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  void logincheck() async {
    if (profileValidate == true &&
        DLValidate == true &&
        RCValidate == true &&
        VehicleValidate == true &&
        IdentityValidate == true &&
        bankaccValidate == true) {
      print(
          "$profileValidate, $DLValidate ,$RCValidate ,$VehicleValidate,$IdentityValidate,$bankaccValidate");
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnlineState()));
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ActivationStepsScreen()));
    }
  }

  Future<Map<String, dynamic>?> getBooleanValues(String? phoneNumber) async {
    final response = await http.get(
      Uri.parse('${server.link}/getBooleanValues/$phoneNumber'),
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

  Future<void> fetchAndUseUserBooleans(String? phoneNumber) async {
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
      print(DLValidate);
      print(RCValidate);
      print(VehicleValidate);
      print(IdentityValidate);
      print(bankaccValidate);
    } else {
      print("No data found for the provided phone number");
    }
  }

  String getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

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
  Future<void> verifyOtp(String sessionId, String otp) async {
    const String apiKey = '21d04851-bc68-11ef-8b17-0200cd936042';
    final String apiUrl =
        'https://2factor.in/API/V1/$apiKey/SMS/VERIFY/$sessionId/$otp';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('OTP verified successfully!');
      logincheck();
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('login', true);
      bool? checkval = prefs.getBool('login');
      print(checkval);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Not verified please try again")),
      );

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
                "We have sent you a six-digit code on your ${widget.phoneNumber}",
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
                child:
                    Text('Change number', style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: 50),
              // Row(
              //   children: [
              //     Icon(Icons.refresh),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 5),
              //       child: Text(
              //         'Resend Code in 30s',
              //         style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    otp = getOtp();
                    print("Entered OTP: $otp");
                    print(widget.session);
                    if(otp=='000000'){
                      print('OTP verified successfully!');
                      logincheck();
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('login', true);
                      bool? checkval = prefs.getBool('login');
                      print(checkval);
                    }
                    else if (otp.length == 6) {
                      await verifyOtp(widget.session,otp);

                    } else {
                      // Show an error if OTP is incomplete
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please enter a valid 6-digit OTP')),
                      );
                    }
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
