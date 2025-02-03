import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/earning/screens/payout_details.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:uig/features/earning/widgets/perform_data.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/serverlink.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DailyChart extends StatelessWidget {
  final double Earning;
  final int Rides;
  const DailyChart({super.key,required this.Earning,required this.Rides});

  double Calculator(){
    if(Rides==0){
      return 0.0;
    }
    else {
      double value = Earning / Rides;

      return value;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 15),
      ),
      child: Column(
        children: [
          SizedBox(
            height: ResponsiveSize.height(context, 174),
            width: ResponsiveSize.width(context, 352),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Performance of Today",
                    style: AppTextStyles.baseStyle,
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 20)),
                  Container(
                    height: ResponsiveSize.height(context, 100),
                    width: ResponsiveSize.width(context, 322),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ResponsiveSize.width(context, 8)),
                      color: AppColors.boxColor,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 17,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                          color: AppColors.shadowColor,
                        ),
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
                            PerformData(
                              text: "Earning",
                              value: "₹$Earning",
                            ),
                            // VerticalDivider(
                            //   thickness: ResponsiveSize.width(context, 2),
                            //   endIndent: ResponsiveSize.height(context, 10),
                            //   indent: ResponsiveSize.height(context, 10),
                            //   color: AppColors.secondaryColor,
                            // ),
                            // const PerformData(
                            //   text: "Trip time",
                            //   value: "1hr",
                            // ),
                            VerticalDivider(
                              thickness: ResponsiveSize.width(context, 2),
                              endIndent: ResponsiveSize.height(context, 10),
                              indent: ResponsiveSize.height(context, 10),
                              color: AppColors.secondaryColor,
                            ),
                             PerformData(
                              text: "Rides",
                              value: "$Rides",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Earning for Tuesday",
                style: AppTextStyles.baseStyle,
              ),
              Text(
                "₹$Earning",
                style: AppTextStyles.baseStyle,
              ),
            ],
          ),

          SizedBox(height: ResponsiveSize.height(context,5)),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayoutDetails(),
                ),
              );
            },
            leading: Container(
              height: ResponsiveSize.height(context, 28),
              width: ResponsiveSize.width(context, 28),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor
              ),
              child: const Icon(
                Icons.two_wheeler,
                color:AppColors.backgroundColor
              ),
            ),
            title: const Text(
              "Trip Earning",
              style: AppTextStyles.baseStyle,
            ),
            subtitle: Text(
              "Earning per trip",
              style: AppTextStyles.smalltitle
                  .copyWith(fontSize: ResponsiveSize.height(context, 10.72)),
            ),
            trailing: Text(
              "₹${Calculator()}",
              style: AppTextStyles.baseStyle,
            ),
          ),
        ],
      ),
    );
  }
}
