
import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/features/online/screens/online_state.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:uig/main.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
class PaymentTrip extends StatefulWidget{
  const PaymentTrip({super.key});

  @override
  State<PaymentTrip> createState() => _PaymentTrip();

}
class _PaymentTrip extends State<PaymentTrip>{
  int selectedRating=0;

  double withdraw=0;
  String? phone_number;
  bool info=false;
  double? price;
  double? dearning;
  String? mode;
  double? comm;
  @override
  void initState() {
    super.initState();
    Waiting();
  }

  // Fetch phone number and user booleans
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
      price=prefs.getDouble('Price');
      print(price);
      dearning=prefs.getDouble('Drivermoney');
      print(dearning);
      mode=prefs.getString('PaymentMode');
      print(mode);
      comm=prefs.getDouble('Commission');
    });
    print('Retrieved phone number: $phone_number');
  }
  void Waiting() async{
    await _getPhoneNumber();
    print(phone_number);
    await withdrawfetchUser(phone_number);
    await withdrawinsertUser(phone_number);
    if(mode=="cash"){
      await addFieldtoUserforCash(phone_number);
    }
    else {
      await addFieldtoUser(phone_number);
    }

  }
  Future<void> withdrawfetchUser(String? phonenumber) async {
    final response = await http.get(Uri.parse('${server.link}/withdrawfindUser/$phonenumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      withdraw = (data['balance'] is int) ? (data['balance'] as int).toDouble() : data['balance'];
      print(withdraw);
      setState(() {
        info=true;
      });

    } else if (response.statusCode == 404) {
      print('User not found');
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  Future<void> withdrawinsertUser(String? phoneNumber) async {
    if (!info) {
      final response = await http.post(
        Uri.parse('${server.link}/withdrawinsertUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phonenumber': phoneNumber,

          'balance': 0.0
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['message']);
      } else {
        throw Exception('Failed to insert user');
      }
    }
  }
  Future<void> addFieldtoUser(String? phoneNumber) async {
    print(dearning!.toDouble());
    final response = await http.post(
      Uri.parse('${server.link}/withaddFieldToUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phonenumber': phoneNumber,
        'userData': {'balance': withdraw + dearning!.toDouble()},
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          final data = json.decode(response.body);
          print('Decoded JSON: $data');
        } catch (e) {
          print('Error decoding response: $e');
        }
      } else {
        print('Error: Empty response body');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

  }
  Future<void> addFieldtoUserforCash(String? phoneNumber) async {
    print(dearning!.toDouble());
    final response = await http.post(
      Uri.parse('${server.link}/withaddFieldToUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phonenumber': phoneNumber,
        'userData': {'balance': withdraw - comm!.toDouble()},
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          final data = json.decode(response.body);
          print('Decoded JSON: $data');
        } catch (e) {
          print('Error decoding response: $e');
        }
      } else {
        print('Error: Empty response body');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) {
                return route.isFirst || route.settings.name == const OnlineState();
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OnlineState()));


            },
            icon: const Icon(Icons.home,color: AppColors.primaryColor,)),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: ResponsiveSize.height(context, 150),
          left: ResponsiveSize.width(context, 17),
          right: ResponsiveSize.width(context, 17),
        ),
        child: Container(
          height: ResponsiveSize.height(context, 440),
          width: ResponsiveSize.width(context, 326),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(ResponsiveSize.width(context, 12)),
            color: AppColors.backgroundColor,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: ResponsiveSize.height(context, 20),
                    ),
                    child: Text(
                      "₹$price",
                      style: AppTextStyles.baseStyle.copyWith(
                          fontSize: ResponsiveSize.height(context, 32)),
                    ),
                  ),
                  Text(
                    "Cash to collect",
                    style: AppTextStyles.smalltitle,
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveSize.height(context, 15),
              ),
              // Details Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total",
                          style: AppTextStyles.smalltitle,
                        ),
                        Text(
                          "₹$price",
                          style: AppTextStyles.smalltitle
                              .copyWith(color: AppColors.blackColor),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount",
                          style: AppTextStyles.smalltitle,
                        ),
                        Text(
                          "₹00",
                          style: AppTextStyles.smalltitle
                              .copyWith(color: AppColors.blackColor),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Wallet", style: AppTextStyles.smalltitle),
                        Text("₹$dearning",
                            style: AppTextStyles.smalltitle
                                .copyWith(color: AppColors.blackColor)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 20)),
              // Time and Distance Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Time",
                        style: AppTextStyles.subtitle,
                      ),
                      Text(
                        "15min",
                        style: AppTextStyles.subtitle.copyWith(
                            fontSize: ResponsiveSize.height(context, 16)),
                      ),
                    ],
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 60)),
                  Column(
                    children: [
                      Text(
                        "Distance",
                        style: AppTextStyles.subtitle,
                      ),
                      Text(
                        "5.2 Km",
                        style: AppTextStyles.subtitle.copyWith(
                            fontSize: ResponsiveSize.height(context, 16)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 5)),
              // Rate Customer Section
              Text(
                "Rate your customer",
                style: AppTextStyles.subtitle
                    .copyWith(fontSize: ResponsiveSize.height(context, 16)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = index + 1; // Update the rating
                      });
                    },
                    child: SizedBox(
                      height: ResponsiveSize.height(context, 37.8),
                      width: ResponsiveSize.width(context, 39.26),
                      child:  Icon(
                        Icons.star,
                        color:
                        index<selectedRating?
                        const Color(
                          0xFFFFD600,
                        ):AppColors.secondaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 60)),
              // Bottom Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ResponsiveSize.height(context, 46),
                  width: ResponsiveSize.width(context, 437),
                  decoration: const BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child:Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: (){
                        Navigator.popUntil(context, (route) {
                          return route.isFirst || route.settings.name == const OnlineState();
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OnlineState()));
                      },
                      child: Text(
                        "Get ready for next ride",
                        style: AppTextStyles.baseStyle2,
                      ),
                    ),
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