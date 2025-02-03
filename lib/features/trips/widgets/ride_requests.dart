import 'package:uig/commons/animated_widget/redline_animation.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class RideRequests extends StatelessWidget {
  const RideRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding:   const EdgeInsets.only(top: 17,bottom: 17),
      child: SizedBox(
        height: ResponsiveSize.height(context, 143),
        width:  ResponsiveSize.width(context, 320),
            child: Container(
      height: ResponsiveSize.height(context, 123),width: ResponsiveSize.width(context, 311),
      decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColors.backgroundColor,
      boxShadow: const [
        BoxShadow(
          color:AppColors.shadowColor,
          blurRadius: 17,spreadRadius: 0,offset: Offset(0, 4)
        )
      ]),
      child:  Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Finding ride request", style: AppTextStyles.baseStyle),
          ),
          SizedBox(
            height: ResponsiveSize.height(context, 15),
          ),
          const RedLineAnimation(),
           SizedBox(
            height: ResponsiveSize.height(context, 15),
          ),
          SizedBox(
            height: ResponsiveSize.height(context, 59),
            width:  ResponsiveSize.height(context,302),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Earnings",
                      style:AppTextStyles.baseStyle.copyWith(fontSize: 10.72),
                    ),
                     SizedBox(
                      height:  ResponsiveSize.height(context, 10),
                    ),
                    const Text(
                      "₹300",
                      style: AppTextStyles.baseStyle,
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 2,
                  endIndent: 10,
                  indent: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Trip Time",
                      style:AppTextStyles.baseStyle.copyWith(fontSize: 10.72),
                    ),
                    SizedBox(
                      height:  ResponsiveSize.height(context, 10),
                    ),
                    const Text(
                      "30 min",
                      style: AppTextStyles.baseStyle,
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 2,
                  endIndent: 10,
                  indent: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Rides",
                      style: AppTextStyles.baseStyle.copyWith(fontSize: 10.72),
                    ),
                    SizedBox(
                      height:  ResponsiveSize.height(context, 10),
                    ),
                    const Text(
                      "3",
                      style: AppTextStyles.baseStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          
        ],
      ),
            ),
          ),
    );
  }
}
