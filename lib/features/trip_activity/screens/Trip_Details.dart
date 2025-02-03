import 'package:uig/features/trip_activity/widgets/TripData.dart';
import 'package:uig/features/trip_activity/widgets/earning_breakdown.dart';
import 'package:uig/features/explore/widgets/time_line.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripDetails extends StatelessWidget {
  final dynamic activity;

  const TripDetails({super.key, required this.activity});
  String formatDate(String timestamp) {
    DateTime parsedDate = DateTime.parse(timestamp);
    return DateFormat('EEE, d MMM yyyy, hh:mm a').format(parsedDate); // Example: Sat, 14 Dec 2024, 06:18 AM
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
            )),
        title: Text(
          "Trip Details",
          style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.w600),
        ),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(
                left: ResponsiveSize.height(context, 13),
                right: ResponsiveSize.height(context, 13),
            top: ResponsiveSize.height(context, 20),
            bottom: ResponsiveSize.height(context, 10)
              ),
              child: Container(
                 height: ResponsiveSize.height(context, 100),
                 width: ResponsiveSize.width(context, 330),
                 decoration: BoxDecoration(
                   border: Border.all(
                     color: AppColors.boxColor,
                     width: ResponsiveSize.width(context, 1),
                   ),
                   borderRadius: BorderRadius.circular(
                     ResponsiveSize.width(context, 8),
                   ),
                   color: AppColors.primaryColor,
                   boxShadow: const [
                     BoxShadow(
                       blurRadius: 3,
                       offset: Offset(0, 4),
                       spreadRadius: 0,
                       color:AppColors.shadowColor
                     )
                   ],
                 ),
                 child: Padding(
                   padding: EdgeInsets.all(
                     ResponsiveSize.width(context, 25),
                   ),
                   child: SizedBox(
                     height: ResponsiveSize.height(context, 59),
                     width: ResponsiveSize.width(context, 286),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         TripData(text: "Earning", value: " ₹${activity['totalFare']} "),
                         // VerticalDivider(
                         //   thickness: ResponsiveSize.width(context, 2),
                         //   endIndent: ResponsiveSize.height(context, 10),
                         //   indent: ResponsiveSize.height(context, 10),
                         //   color: AppColors.secondaryColor
                         // ),
                         // TripData(text: "Trip time", value: "15 min"),
                         VerticalDivider(
                           thickness: ResponsiveSize.width(context, 2),
                           endIndent: ResponsiveSize.height(context, 10),
                           indent: ResponsiveSize.height(context, 10),
                           color: AppColors.secondaryColor
                         ),
                         TripData(text: "Distance", value: "${activity['distance']} Km"),
                       ],
                     ),
                   ),
                 ),
               ),
            ),
          
            Text(formatDate(activity['createdAt']),style: AppTextStyles.smalltitle,),
            SizedBox(height: ResponsiveSize.height(context, 15),),
              Container(
              height: ResponsiveSize.height(context, 32),
              width: ResponsiveSize.width(context, 360),
              color: AppColors.purplebackground,
              child:  Padding(
                padding: const EdgeInsets.only(left:8,top: 8),
                child: Text(
                        "Trp ID: 23243554",
                        style: AppTextStyles.baseStyle.copyWith(
                            color: AppColors.primaryColor, fontSize: 13.28),
                      ),
              )
        
        ),
              
                  Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: TimeLinewidget(
                      isfirst: true,
                      islast: false,
                      isPast: true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: ResponsiveSize.width(context, 8),
                          top: ResponsiveSize.height(context, 25),
                        ),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Pickup at",
                              style: AppTextStyles.baseStyle.copyWith(
                                fontSize:16
                              )),
                          TextSpan(
                              text:
                                  "\n${activity['currentAddress']}",
                              style: AppTextStyles.smalltitle),
                        ])),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: TimeLinewidget(
                      isfirst: false,
                      islast: true,
                      isPast: true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: ResponsiveSize.width(context, 8),
                          bottom: ResponsiveSize.height(context, 5),
                        ),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Dropoff at",
                              style: AppTextStyles.baseStyle.copyWith(
                                fontSize:16
                              )),
                          TextSpan(
                              text:
                                  "\n${activity['destinationAddress']}",
                              style: AppTextStyles.smalltitle),
                        ])),
                      ),
                    ),
                  ),
                
                ListTile(
                    leading: Image.asset('assets/images/Ganesh.png'),
                    title: Text(
                      "${activity['userName']}",
                      style: AppTextStyles.baseStyle,
                    ),
                    trailing: Container(
                      height: ResponsiveSize.height(context, 17),
                      width: ResponsiveSize.width(context, 40),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColors.blacktextColor),
                        borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 12)),
                        color: AppColors.backgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centers the content
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "4.4",
                            style: AppTextStyles.subtitle,
                          ),
                          SizedBox(width: 4), // Adds some space between the text and star
                          Icon(
                            Icons.star,
                            color: Color(0xFFFFD600),
                            size: 14, // Increased size for better visibility
                          ),
                        ],
                      ),
                    ),

                ),
           // Padding(
           //   padding: const EdgeInsets.only(right: 160.0,top: 15,bottom: 15),
           //   child: Text("Earning Breakdown",style: AppTextStyles.headline,
           //         ),
           // ),
           // const EarningBreakdown(),
           // Padding(
           //   padding:  EdgeInsets.symmetric(
           //    horizontal: ResponsiveSize.height(context, 12),
           //    vertical:  ResponsiveSize.height(context, 12),
           //   ),
           //   child: Container(
           //     width: ResponsiveSize.width(context, 340),
           //      height: ResponsiveSize.height(context, 47),
           //      decoration: BoxDecoration(
           //        borderRadius: BorderRadius.circular(4),
           //        border: Border.all(
           //          width: 1,color: AppColors.secondaryColor
           //        )
           //
           //      ),child: Row(
           //        mainAxisAlignment: MainAxisAlignment.spaceAround,
           //        children: [
           //          Text("Need help on this trip?",style: AppTextStyles.baseStyle.copyWith(
           //            fontSize: 13.28
           //          ),),
           //           Text("Help center",style: AppTextStyles.baseStyle.copyWith(
           //            fontSize: 13.28,color: AppColors.greenColor
           //          ),),
           //
           //        ],
           //      ),
           //   ),
           // )
          ],
        ),
      ),
    );
  }
}