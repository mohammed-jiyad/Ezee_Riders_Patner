
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: ResponsiveSize.height(context, 261),
        width: ResponsiveSize.width(context, 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Help and Support",style: AppTextStyles.headline,),
            SizedBox(height: ResponsiveSize.height(context, 10)),
            SizedBox(
              height:ResponsiveSize.height(context, 89),
              width: ResponsiveSize.width(context, 323),
              
              child: ListTile(
                leading: const Icon(Icons.help,color:AppColors.blackColor,),
                title: const Text("Get your queries resolved",style: AppTextStyles.baseStyle,),
                subtitle: Text("Call or chat with us at anytime and get your issues resolve instantly.",style: AppTextStyles.subtitle,),
              ),
            ),
             SizedBox(
                 height:ResponsiveSize.height(context, 89),
              width: ResponsiveSize.width(context, 323),
              
              child: ListTile(
                leading: const Icon(Icons.info,color: AppColors.blackColor,),
                title: const Text("Setup your emergency contact ",style: AppTextStyles.baseStyle,),
                subtitle: Text("we’ll contact them if an issue is reported and you don’t respond.",style: AppTextStyles.subtitle,),
              ),
            )
          ],
        ),
      ),
    );
  }
}