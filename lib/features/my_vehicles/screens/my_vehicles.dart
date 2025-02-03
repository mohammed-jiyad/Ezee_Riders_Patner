import 'package:uig/features/my_vehicles/screens/vehicle_details.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:uig/utils/serverlink.dart';
class MyVehicles extends StatefulWidget{
  const MyVehicles({super.key});
  @override
  State<MyVehicles> createState()=>_MyVehicles();

}
class _MyVehicles extends State<MyVehicles> {
  String? phone_number;
  List<dynamic> data=[];
  @override
  void initState() {

    super.initState();
    get();
  }
  void get()async{
    await _getPhoneNumber();
    if (phone_number != null) {
      print('Calling Fetchdata');
      SearchUser(phone_number.toString());
    }
  }
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number for Earning: $phone_number'); // Print for debugging
  }
  Future<void> SearchUser(String phno) async {
    final url = '${server.link}/searchUser/$phno';
    print('Logging URL');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('data found');
      setState(() {
        data = [json.decode(response.body)]; // Store the returned user object
      });
    } else if (response.statusCode == 404) {
      print('No user found for the provided phone number');
      setState(() {
        data = []; // Empty list if no user is found
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.blackColor,
          ),
        ),
        title: Text(
          "My Vehicles",
          style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: data.isNotEmpty
            ? ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  VehicleDetails(data: data,)),
            );
          },
          leading: const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.secondaryColor,
            child: Icon(
              Icons.two_wheeler,
              size: 19,
              color: AppColors.greytextColor,
            ),
          ),
          title: Text(
            "${data[0]['vehiclecompany']}",
            style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),
          ),
          subtitle: Text(
            "${data[0]['vehiclenumber']}",
            style: AppTextStyles.subtitle,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        )
            : Center(child: CircularProgressIndicator()), // Show a loading indicator while fetching
      ),
    );
  }

}
