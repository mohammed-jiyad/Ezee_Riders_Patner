import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
class DriverBox extends StatelessWidget {

  const DriverBox({super.key, required this.title, this.onTap});
  final String title;
  final dynamic onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Container(
        height: ResponsiveSize.height(context, 60),
        width: ResponsiveSize.width(context, 328),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1,color: AppColors.docboxColor),
          color: AppColors.docboxColor1
        ),child: ListTile(
          onTap: onTap,
          leading:  Container(
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
                                   title: Text(title,style: AppTextStyles.baseStyle,),
                               trailing: const Icon(Icons.arrow_forward_ios,size: 24,),
        ),
      ),
    );
  }
}