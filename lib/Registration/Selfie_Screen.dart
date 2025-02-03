import 'Profile_Screen.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uig/utils/serverlink.dart';
class SelfieScreen extends StatefulWidget {
  @override
  _SelfieScreenState createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool isCameraInitialized = false;
  String? phoneNumber;
  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
    initializeCamera();
  }
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = prefs.getString('phone_number');
    });
    print('Retrieved phone number: $phoneNumber');
  }
  Future<void> uploadFileToServer(String? phoneNumber, Uint8List fileData, String fileName, String title) async {
    try {
      var uri = Uri.parse("${server.link}/uploadFileForUser");

      var request = http.MultipartRequest('POST', uri)
        ..fields['phoneNumber'] = phoneNumber.toString()
        ..fields['uploadTitle'] = title
        ..files.add(http.MultipartFile.fromBytes('file', fileData, filename: fileName));


      var response = await request.send();

      if (response.statusCode == 200) {
        print("File uploaded successfully.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully.")));
      } else {
        print("Failed to upload file: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload file.")));
      }
    } catch (e) {
      print("Error while uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading file.")));
    }
  }
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();

    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<Uint8List> captureImageAsBytes() async {
    try {

      await _initializeControllerFuture;


      final image = await _cameraController.takePicture();


      final imageFile = File(image.path);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      return imageBytes;
    } catch (e) {
      throw Exception("Error capturing image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Selfie',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: isCameraInitialized
                ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Stack(
              children: [
                // Capture button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          // Capture image as bytes
                          final imageBytes = await captureImageAsBytes();
                          uploadFileToServer(phoneNumber, imageBytes, 'ProfilePicture', 'profile');
                          // Do something with the bytes (e.g., upload, process)
                          print("Image captured as bytes: ${imageBytes.length} bytes");

                          // Example: Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Image captured successfully!")),
                          );
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileFormPage()));
                        } catch (e) {
                          print("Error capturing image: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to capture image.")),
                          );
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 6),
                        ),
                      ),
                    ),
                  ),
                ),

                // Cancel button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, right: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.close, size: 60, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
