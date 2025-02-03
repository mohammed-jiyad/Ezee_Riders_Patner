import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class TripData extends StatelessWidget {
  const TripData({super.key, required this.text, required this.value});
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text,
        style: AppTextStyles.baseStyle.copyWith(
          color: AppColors.backgroundColor,
          fontSize: 10.72
        ),),const SizedBox(height: 5,),
        Text(value,style: AppTextStyles.headline.copyWith(
          color:AppColors.backgroundColor,
          fontWeight:FontWeight.w600
        ),)
      ],
    );
  }
}
