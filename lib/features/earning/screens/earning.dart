import 'package:uig/features/earning/widgets/daily_chart.dart';
import 'package:uig/features/earning/widgets/monthly%20_chart.dart';
import 'package:uig/features/earning/widgets/monthly_earning.dart';
import 'package:uig/features/earning/widgets/monthly_perform.dart';
import 'package:uig/features/earning/widgets/tab_bar_row.dart';
import 'package:uig/features/earning/widgets/weekly_chart.dart';
import 'package:uig/features/earning/widgets/weekly_earning.dart';
import 'package:uig/features/earning/widgets/weekly_perform.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:uig/utils/serverlink.dart';
class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  String selectedTab = "weekly";
  String? phone_number;
  double price=0.0;
  List<dynamic> data=[];
  @override
  void initState() {

    super.initState();
    get();
  }
  void get()async{
    data=[];
    await _getPhoneNumber();
    if (phone_number != null) {
      print('Calling Fetchdata');
      fetchData(phone_number!, selectedTab);  // Call fetchData only after phone_number is not null
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
  Future<List<dynamic>> fetchData(String phno, String filter) async {
    print(filter);
    final url = '${server.link}/tripinfo/$phno?filter=$filter';
    print('Logging URL');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data=List<dynamic>.from(json.decode(response.body));
      double totalPrice = 0.0;
      for (var activity in data) {
        print(activity['price']);
        totalPrice += double.tryParse(activity['price'].toString()) ?? 0.0;
      }

      print('Total Price: $totalPrice');
      setState(() {
        data=List<dynamic>.from(json.decode(response.body));
        price=totalPrice;
      });
      print(data);
      print(price);
      return List<dynamic>.from(json.decode(response.body));
    }
    else if(response.statusCode == 404){
      print('No User found for earning');
      setState(() {
        data=[];
        price=0.0;
      });
      return [];
    }
    else {
      throw Exception("Failed to load data");
    }
  }

  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const HelpScreen();
        });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.backgroundColor,
      appBar:    AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: AppColors.backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 12),
              vertical: ResponsiveSize.height(context, 12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 29),
              child: SizedBox(
                width: ResponsiveSize.width(context, 360),
                height: ResponsiveSize.height(context, 51),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child: InkWell(
                                onTap: () => _showHelpPage(context),
                                child:
                                const Icon(Icons.help_outline_rounded)),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child:
                            const Icon(Icons.notifications_none_outlined),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child: const Icon(
                              Icons.warning_amber,
                              color: AppColors.redColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBarRow(selectedTab:selectedTab, onTapSelectedTab: (tab){
               WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      print('Printing value in earning $tab');
      selectedTab = tab;
      fetchData(phone_number.toString(), tab);
    });
  });
            },),
            if(selectedTab=="daily")...[

            DailyChart(Earning: price,Rides: data.length,),
             Container(),
            ]else...[
              if(selectedTab=="weekly")...[
        //      WeeklyChart()
                 WeeklyPerformance(Earning: price,Rides: data.length,),

                const SizedBox(height: 30,),
                 WeeklyEarning(Earning: price,Rides: data.length,),],
              if(selectedTab=="monthly")...[
               // MonthlyChart(),
                MonthlyPerformance(Earning: price,Rides: data.length,),
                const SizedBox(height: 30,),
                MonthlyEarning(Earning: price,Rides: data.length,),],


            ]


          ],
        ),
      ),

    );

  }
  
}