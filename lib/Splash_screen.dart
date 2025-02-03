import 'package:uig/Registration/Registration.dart';
import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/features/online/screens/online_state.dart';
import 'package:uig/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uig/utils/serverlink.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentImageIndex = 0;
  bool isLoading = true;
  bool profileSubmit = false;
  bool profileValidate = false;
  bool profileRejected = false;
  bool DLSubmit = false;
  bool DLValidate = false;
  bool DLRejected = false;
  bool RCSubmit = false;
  bool RCValidate = false;
  bool RCRejected = false;
  bool VehicleSubmit = false;
  bool VehicleValidate = false;
  bool VehicleRejected = false;
  bool IdentitySubmit = false;
  bool IdentityValidate = false;
  bool IdentityRejected = false;
  bool bankaccSubmit = false;
  bool bankaccValidate = false;
  bool bankaccRejected = false;
  bool? logincred;
  String? Name;
  String? Vehiclenumber;
  String? Vehicletype;
  String? phno;
  LatLng? userLocation;

  final List<String> _images = [
    'assets/Splashscreen1.jpg',
    'assets/SplashScreen2.jpg',
    'assets/SplashScreen3.jpg',
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    logincred = prefs.getBool('login');
    if (logincred == true) {
      phno = prefs.getString('phone_number');
      if (phno != null) {
        await fetchAndUseUserBooleans(phno);
        if (profileValidate && DLValidate && RCValidate && VehicleValidate && IdentityValidate && bankaccValidate) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnlineState()));
          return;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchAndUseUserBooleans(String? phoneNumber) async {
    final response = await http.get(Uri.parse('${server.link}/getBooleanValues/$phoneNumber'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        profileSubmit = data['profilesubmit'] ?? false;
        profileValidate = data['profilevalidate'] ?? false;
        profileRejected = data['profilerejected'] ?? false;
        DLSubmit = data['DLsubmit'] ?? false;
        DLValidate = data['DLvalidate'] ?? false;
        DLRejected = data['DLrejected'] ?? false;
        RCSubmit = data['RCsubmit'] ?? false;
        RCValidate = data['RCvalidate'] ?? false;
        RCRejected = data['RCrejected'] ?? false;
        VehicleSubmit = data['Vehiclesubmit'] ?? false;
        VehicleValidate = data['Vehiclevalidate'] ?? false;
        VehicleRejected = data['Vehiclerejected'] ?? false;
        IdentitySubmit = data['Identitysubmit'] ?? false;
        IdentityValidate = data['Identityvalidate'] ?? false;
        IdentityRejected = data['Identityrejected'] ?? false;
        bankaccSubmit = data['bankaccsubmit'] ?? false;
        bankaccValidate = data['bankaccvalidate'] ?? false;
        bankaccRejected = data['bankaccrejected'] ?? false;
        Name = data['fullname'] ?? "";
        Vehiclenumber = data['vehiclenumber'] ?? "";
        Vehicletype = data['vehicletype'] ?? "";
      });
    }
  }

  void _goToNextPage() {
    if (_currentImageIndex < _images.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    else if (_currentImageIndex==_images.length-1){
      logincheck();
    }
  }

  void _goToLastPage() {
    setState(() {
      _currentImageIndex = _images.length - 1;
    });
    _pageController.animateToPage(
      _currentImageIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    logincheck();
  }

  Future<void> logincheck() async{
    if(logincred==true){
      if(profileValidate==true &&DLValidate==true && RCValidate==true && VehicleValidate==true && IdentityValidate==true && bankaccValidate==true){
        print("$profileValidate, $DLValidate ,$RCValidate ,$VehicleValidate,$IdentityValidate,$bankaccValidate");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OnlineState()));
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PhoneLoginScreen()));
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ActivationStepsScreen()));
      }
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>PhoneLoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              );
            },
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: _currentImageIndex <= _images.length - 1
                ? TextButton(
              onPressed: _goToNextPage,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            )
                : Container(),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: _currentImageIndex < _images.length - 1
                ? TextButton(
              onPressed: _goToLastPage,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
            )
                : Container(),
          ),
        ],
      ),
    );
  }
}
