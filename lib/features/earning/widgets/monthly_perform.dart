import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:uig/features/earning/widgets/perform_data.dart';
import 'package:flutter/material.dart';


class MonthlyPerformance extends StatelessWidget {
  final double Earning;
  final int Rides;
  const MonthlyPerformance({super.key,required this.Earning,required this.Rides});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveSize.height(context, 174),
      width: ResponsiveSize.width(context, 352),
      child: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveSize.width(context, 13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Performance of this Month",
              style: AppTextStyles.baseStyle2.copyWith(color: AppColors.blackColor,fontSize: 16),
            ),
            SizedBox(height: ResponsiveSize.height(context, 20)),
            Container(
              height: ResponsiveSize.height(context, 100),
              width: ResponsiveSize.width(context, 322),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.boxColor,
                  width: ResponsiveSize.width(context, 1),
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveSize.width(context, 8),
                ),
                color: AppColors.backgroundColor,
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
                      PerformData(text: "Earning", value: "₹$Earning"),
                      // VerticalDivider(
                      //     thickness: ResponsiveSize.width(context, 2),
                      //     endIndent: ResponsiveSize.height(context, 10),
                      //     indent: ResponsiveSize.height(context, 10),
                      //     color: AppColors.secondaryColor
                      // ),
                      // const PerformData(text: "Trip time", value: "30 min"),
                      VerticalDivider(
                          thickness: ResponsiveSize.width(context, 2),
                          endIndent: ResponsiveSize.height(context, 10),
                          indent: ResponsiveSize.height(context, 10),
                          color: AppColors.secondaryColor
                      ),
                      PerformData(text: "Rides", value: "$Rides"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
