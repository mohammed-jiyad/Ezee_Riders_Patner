import 'package:uig/features/documents/widgets/blank_box.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
class VehicleRc extends StatelessWidget {
  const VehicleRc({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
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
            )),
      ),
      body: Padding(
           padding: const EdgeInsets.only(left: 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Vehicle RC",style: AppTextStyles.headline,),
          SizedBox(height: ResponsiveSize.height(context, 40),),
          BlankBox(name: "RC Upload Front",),
          BlankBox(name:"RC Upload Back" ,),
          BlankBox(name:"Upload License Plate" ,)
        ],
            ),
      ));

  }
}