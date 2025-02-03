import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class DeleteContacts extends StatelessWidget {
  const DeleteContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(context, 360),
      height: ResponsiveSize.height(context, 244),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveSize.height(context, 20),
            ),
            Text(
              "Delete emergency contact",
              style: AppTextStyles.baseStyle2.copyWith(
                  color: AppColors.newtextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: ResponsiveSize.height(context, 6),
            ),
            Text(
              "Are you sure you want to delete Mr. Roy as an emergency conatct?",
              style: AppTextStyles.baseStyle2.copyWith(
                  color: AppColors.greytextColor, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: ResponsiveSize.height(context, 40),
            ),
            SizedBox(
              width: ResponsiveSize.width(context, 338),
              height: ResponsiveSize.height(context, 38),
             
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  onPressed: () {},
                  child: const Text(
                    "Delete",
                    style: AppTextStyles.baseStyle2,
                  )),
            ),
            SizedBox(
              height: ResponsiveSize.height(context, 10),
            ),
            Container(
              width: ResponsiveSize.width(context, 338),
              height: ResponsiveSize.height(context, 38),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go Back",
                    style: AppTextStyles.baseStyle2
                        .copyWith(color: AppColors.primaryColor),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
