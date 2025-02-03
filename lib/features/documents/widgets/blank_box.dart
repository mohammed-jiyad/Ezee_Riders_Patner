import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
class BlankBox extends StatefulWidget {
  final String name;
  const BlankBox({super.key, required this.name});

  @override
  State<BlankBox> createState() => _BlankBox();
}

class _BlankBox extends State<BlankBox> {
  String? phone_number;
  String? imageUrl;
  String? base64String;

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
  }

  // Method to fetch phone number from shared preferences
  void getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Debugging the phone number
    print('Retrieved phone number for Documents: $phone_number');
  }

  // Method to retrieve the Base64 image string from the server
  Future<String> RetrieveDocs(String phno, String Name) async {
    final response = await http.get(
      Uri.parse('${server.link}/fetchFileForUser?phoneNumber=$phno&uploadTitle=$Name'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Debugging the response

      // Assuming the backend returns the Base64 string in 'fileData'
      final base64Str = data; // Adjust this based on your backend response

      return base64Str;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to fetch file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 10),
      child: Container(
        height: ResponsiveSize.height(context, 205),
        width: ResponsiveSize.width(context, 292),

        child: phone_number == null // Wait until phone_number is fetched
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<String>(
          future: RetrieveDocs(phone_number!, widget.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              // Decode the Base64 string to bytes
              final bytes = base64Decode(snapshot.data!);

              return Center(
                child: Image.memory(Uint8List.fromList(bytes)),
              );
            }

            return Center(child: Text('No image found'));
          },
        ),
      ),
    );
  }
}
