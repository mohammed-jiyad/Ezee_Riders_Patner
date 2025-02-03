
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class VehicleDetails extends StatelessWidget {
  final dynamic data;
  const VehicleDetails({super.key, required this.data});

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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 17,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveSize.height(context, 114),
              width: ResponsiveSize.width(context, 292),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data[0]['vehiclecompany']}",
                            style: AppTextStyles.headline
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${data[0]['vehiclenumber']}",
                            style: AppTextStyles.baseStyle
                                .copyWith(fontSize: 13.28),
                          ),
                          Text(
                            "Petrol",
                            style: AppTextStyles.subtitle,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 27, left: 25),
                        child: Container(
                            height: ResponsiveSize.height(context, 20),
                            width: ResponsiveSize.width(context, 20),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.blackColor),
                            child: const Icon(
                              Icons.check,
                              size: 15,
                              color: AppColors.backgroundColor,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveSize.height(context, 10),
                  ),
                  Row(
                    children: [
                      Text(
                        "Year",
                        style: AppTextStyles.smalltitle
                            .copyWith(color: AppColors.blacktextColor),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${data[0]['Year']}",
                        style: AppTextStyles.baseStyle,
                      )
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveSize.height(context, 8),
                  ),
                  Row(
                    children: [
                      Text(
                        "Color",
                        style: AppTextStyles.smalltitle
                            .copyWith(color: AppColors.blacktextColor),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${data[0]['color']}",
                        style: AppTextStyles.baseStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height:ResponsiveSize.height(context, 10) ,),
            Text("Documents",style: AppTextStyles.headline,),
            ListTile(
              tileColor: AppColors.purplebackground,
              leading: Container(
                  height: ResponsiveSize.height(context, 20),
                  width: ResponsiveSize.width(context, 20),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greenColor),
                  child: const Icon(
                    Icons.check,
                    size: 15,
                    color: AppColors.backgroundColor,
                  )),
              title: Text("Vehicle RC",style: AppTextStyles.baseStyle.copyWith(
                  fontSize: 13.28
              ),),

            ),SizedBox(height: ResponsiveSize.height(context, 5),),
            ListTile(
              tileColor: AppColors.purplebackground,
              leading: Container(
                  height: ResponsiveSize.height(context, 20),
                  width: ResponsiveSize.width(context, 20),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greenColor),
                  child: const Icon(
                    Icons.check,
                    size: 15,
                    color: AppColors.backgroundColor,
                  )),
              title: Text("Vehicle Insurance",style: AppTextStyles.baseStyle.copyWith(
                  fontSize: 13.28
              ),),

            )
          ],
        ),
      ),
    );
  }
}
