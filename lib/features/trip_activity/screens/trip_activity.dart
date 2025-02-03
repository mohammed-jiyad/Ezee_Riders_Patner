import 'package:uig/features/trip_activity/screens/Trip_Details.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class TripActivity extends StatefulWidget {
  const TripActivity({super.key});

  @override
  State<TripActivity> createState() => _TripActivityState();
}

class _TripActivityState extends State<TripActivity> {
  String? phone_number;
  List<dynamic> data=[];

   Future<List<dynamic>> fetchData(String phno) async {
     final response = await http.get(Uri.parse('${server.link}/tripdata/$phno'));

     if (response.statusCode == 200) {
        print(List<dynamic>.from(json.decode(response.body)));
       return List<dynamic>.from(json.decode(response.body));
     } else if (response.statusCode == 404){
       return [];
     }
     else {
       throw Exception("Failed to load data");
     }
   }
   void initState() {
     super.initState();
     _getPhoneNumber();
   }
  String formatDate(String timestamp) {
    DateTime parsedDate = DateTime.parse(timestamp);
    return DateFormat('EEE, d MMM yyyy, hh:mm a').format(parsedDate); // Example: Sat, 14 Dec 2024, 06:18 AM
  }
   Future<void> _getPhoneNumber() async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       phone_number = prefs.getString('phone_number');
     });
     // Retrieve the phone number
     print('Retrieved phone number: $phone_number'); // Print for debugging
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )),
        title: Text(
          "Trip Activity",
          style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: phone_number == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<List<dynamic>>(
          future: fetchData(phone_number!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No activities found"));
            } else {
              final activities = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveSize.height(context, 17)),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1, color: AppColors.secondaryColor),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8, // Set a height constraint
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(), // Enable smooth scrolling
                                itemCount: activities.length,
                                itemBuilder: (context, index) {
                                  final activity = activities[index];
                                  return Container(
                                    width: ResponsiveSize.width(context, 310),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: AppColors.secondaryColor),
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TripDetails(activity: activity),
                                          ),
                                        );
                                      },
                                      leading: const CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.newBoxColor,
                                        child: Icon(
                                          Icons.two_wheeler,
                                          size: 20,
                                          color: AppColors.blacktextColor,
                                        ),
                                      ),
                                      title: Text(
                                        activity['destinationAddress'] ?? "null",
                                        style: AppTextStyles.baseStyle,
                                      ),
                                      subtitle: Text(
                                        formatDate(activity['createdAt']),
                                        style: AppTextStyles.subtitle.copyWith(color: AppColors.blacktextColor),
                                      ),
                                      trailing: SizedBox(
                                        width: ResponsiveSize.width(context, 48),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹ ${activity['price']}',
                                              style: AppTextStyles.smalltitle.copyWith(color: AppColors.blacktextColor),
                                            ),
                                            const Icon(Icons.arrow_forward_ios, size: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.height(context, 10)),
                      // Container(
                      //   height: ResponsiveSize.height(context, 233),
                      //   width: ResponsiveSize.width(context, 340),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(width: 1, color: AppColors.secondaryColor)),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         height: ResponsiveSize.height(context, 42),
                      //         width: ResponsiveSize.width(context, 340),
                      //         decoration: const BoxDecoration(
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(12),
                      //                 topRight: Radius.circular(12)),
                      //             color: AppColors.purplebackground),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 "Sat, 19 July",
                      //                 style: AppTextStyles.smalltitle.copyWith(
                      //                     color: AppColors.primaryColor,
                      //                     fontWeight: FontWeight.w600),
                      //               ),
                      //               Text(
                      //                 "₹240",
                      //                 style: AppTextStyles.smalltitle.copyWith(
                      //                     color: AppColors.primaryColor,
                      //                     fontWeight: FontWeight.w600),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       ListView.builder(
                      //         shrinkWrap: true,
                      //         itemCount: 3,
                      //         itemBuilder: ((context, index) {
                      //           return Container(
                      //             height: ResponsiveSize.height(context, 63),
                      //             width: ResponsiveSize.width(context, 310),
                      //             decoration: const BoxDecoration(
                      //                 border: Border(
                      //                     bottom: BorderSide(
                      //                         width: 1, color: AppColors.secondaryColor))),
                      //             child: ListTile(
                      //               leading: const CircleAvatar(
                      //                   radius: 18,
                      //                   backgroundColor: AppColors.newBoxColor,
                      //                   child: Icon(
                      //                     Icons.two_wheeler,
                      //                     size: 20,
                      //                     color: AppColors.blacktextColor,
                      //                   )),
                      //               title: const Text(
                      //                 'Ride to cafe',
                      //                 style: AppTextStyles.baseStyle,
                      //               ),
                      //               subtitle: Text(
                      //                 '1:09 PM',
                      //                 style: AppTextStyles.subtitle
                      //                     .copyWith(color: AppColors.blacktextColor),
                      //               ),
                      //               trailing: SizedBox(
                      //                 width: ResponsiveSize.width(context, 48),
                      //                 child: Row(
                      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     Text(
                      //                       "₹80",
                      //                       style: AppTextStyles.smalltitle
                      //                           .copyWith(color: AppColors.blacktextColor),
                      //                     ),
                      //                     const Icon(
                      //                       Icons.arrow_forward_ios,
                      //                       size: 12,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           );
                      //         }),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      //  SizedBox(
                      //   height: ResponsiveSize.height(context, 10),
                      // ),
                      // Container(
                      //   height: ResponsiveSize.height(context, 95),
                      //   width: ResponsiveSize.width(context, 340),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(width: 1, color: AppColors.secondaryColor)),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         height: ResponsiveSize.height(context, 42),
                      //         width: ResponsiveSize.width(context, 340),
                      //         decoration: const BoxDecoration(
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(12),
                      //                 topRight: Radius.circular(12)),
                      //             color: AppColors.purplebackground),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 "Sat, 19 July",
                      //                 style: AppTextStyles.smalltitle.copyWith(
                      //                     color: AppColors.primaryColor,
                      //                     fontWeight: FontWeight.w600),
                      //               ),
                      //               Text(
                      //                 "₹240",
                      //                 style: AppTextStyles.smalltitle.copyWith(
                      //                     color: AppColors.primaryColor,
                      //                     fontWeight: FontWeight.w600),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //    const Padding(
                      //      padding: EdgeInsets.all(8.0),
                      //      child: Text("No Activity",style: AppTextStyles.baseStyle,),
                      //    )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),

    );
  }
}