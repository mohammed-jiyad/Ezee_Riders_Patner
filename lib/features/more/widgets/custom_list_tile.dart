
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.icon, required this.text, required this.trailing, this.onTap,required this.coming });
  final Widget icon;
  final String text;
  final Widget trailing;
  final dynamic onTap;
  final bool coming;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      iconColor: AppColors.greytextColor,
      visualDensity: const VisualDensity(vertical: -2),
      leading: Container(
        height: 28,
        width: 28,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppColors.newColor),
        child: icon,),
      title: Row(
        children:[Text(
          text,
          style: AppTextStyles.baseStyle,
        ),
          Spacer(),
          coming==true?Container(
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.indigo ),

              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text('Coming Soon',style: TextStyle(color: Colors.white,fontSize: 13.28),),
              )):Container()
        ]
      ),
      trailing: trailing,


    );
  }
}