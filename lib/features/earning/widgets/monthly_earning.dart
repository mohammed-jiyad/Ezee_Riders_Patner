import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/earning/screens/payout_details.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';


class MonthlyEarning extends StatelessWidget {
  final double Earning;
  final int Rides;
  const MonthlyEarning({super.key,required this.Earning,required this.Rides});
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Earning of this Month", style: AppTextStyles.baseStyle2.copyWith(color: AppColors.blackColor,fontSize: 16),),
              Text("₹$Earning", style:AppTextStyles.baseStyle2.copyWith(color: AppColors.blackColor,fontSize: 16),)
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Earning of last week",
          //       style: AppTextStyles.subtitle.copyWith(
          //           fontSize: 12
          //       ),
          //     ),
          //     Text(
          //       "₹560.09",
          //       style: AppTextStyles.subtitle.copyWith(
          //           fontSize: 12
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: ResponsiveSize.height(context, 254),
            width: ResponsiveSize.width(context, 327),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                        color: AppColors.primaryColor,
                      ),
                      child: const Icon(
                          Icons.two_wheeler,
                          color: AppColors.backgroundColor
                      ),
                    ),
                    title:  Text(
                      "Trip Earning",
                      style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Earning per trip",
                      style: AppTextStyles.smalltitle.copyWith(
                          fontSize: 10.72
                      ),
                    ),
                    trailing: Text(
                      "₹${Calculator()}",
                      style: AppTextStyles.baseStyle,
                    ),
                  ),
                  // ListTile(
                  //   leading: Container(
                  //     height: ResponsiveSize.height(context, 28),
                  //     width: ResponsiveSize.width(context, 28),
                  //     decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: AppColors.yellowColor
                  //     ),
                  //     child: const Icon(
                  //         Icons.bolt,
                  //         color: AppColors.backgroundColor
                  //     ),
                  //   ),
                  //   title:  Text(
                  //     "Surge Pay",
                  //     style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600),
                  //   ),
                  //   subtitle: Text(
                  //     "Extra pay during certain time slots",
                  //     style: AppTextStyles.smalltitle.copyWith(
                  //         fontSize: 10.72
                  //     ),
                  //   ),
                  //   trailing: const Text(
                  //     "₹8.89",
                  //     style: AppTextStyles.baseStyle,
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: Container(
                  //     height: ResponsiveSize.height(context, 28),
                  //     width: ResponsiveSize.width(context, 28),
                  //     decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: AppColors.blueColor
                  //     ),
                  //     child: const Icon(
                  //         Icons.thumb_up,
                  //         color: AppColors.backgroundColor
                  //     ),
                  //   ),
                  //   title:  Text(
                  //     "Customer Tips",
                  //     style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600),
                  //   ),
                  //   trailing: const Text(
                  //     "₹8.89",
                  //     style: AppTextStyles.baseStyle,
                  //   ),
                  // ),
                  ListTile(
                    tileColor: AppColors.newColor,
                    leading: Container(
                      height: ResponsiveSize.height(context, 28),
                      width: ResponsiveSize.width(context, 28),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.greytextColor
                      ),
                      child: const Icon(
                          Icons.currency_rupee,
                          color: AppColors.backgroundColor
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Offers",
                          style: AppTextStyles.baseStyle.copyWith(
                              color:AppColors.greytextColor
                          ),
                        ),
                        Container(
                          height: ResponsiveSize.height(context, 14),
                          width: ResponsiveSize.width(context, 59),
                          decoration: BoxDecoration(
                            color:AppColors.redColor,
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.width(context, 9),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Coming Soon",
                              style: AppTextStyles.baseStyle2.copyWith(
                                  color: AppColors.backgroundColor,
                                  fontSize: 8
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // trailing: Text(
                    //   "₹0.00",
                    //   style: AppTextStyles.baseStyle.copyWith(
                    //       color: AppColors.greytextColor
                    //   ),
                    // ),
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 10)),
                  Text(
                    "Settlement will be calculated at the end of week",
                    style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.blacktextColor
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
