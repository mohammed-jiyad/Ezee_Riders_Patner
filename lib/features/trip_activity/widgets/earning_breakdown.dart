import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class EarningBreakdown extends StatefulWidget {
  const EarningBreakdown({super.key});

  @override
  State<EarningBreakdown> createState() => _EarningBreakdownState();
}

class _EarningBreakdownState extends State<EarningBreakdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveSize.height(context, 203),
        width: ResponsiveSize.width(context, 340),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(width: 1, color: AppColors.secondaryColor),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            const EContainer(
              color: AppColors.backgroundColor,
              child: ListTile(
                title: Text(
                  "Base rate",
                  style: AppTextStyles.baseStyle,
                ),
                trailing: Text(
                  "₹60.00",
                  style: AppTextStyles.baseStyle,
                ),
              ),
            ),
            EContainer(
              color: AppColors.backgroundColor,
              child: ListTile(
                title: const Text(
                  "Time",
                  style: AppTextStyles.baseStyle,
                ),
                subtitle: Text(
                  "6min 43s ",
                  style: AppTextStyles.smalltitle,
                ),
                trailing: const Text(
                  "₹60.00",
                  style: AppTextStyles.baseStyle,
                ),
              ),
            ),
            EContainer(
              color: AppColors.backgroundColor,
              child: ListTile(
                title: const Text(
                  "Distance",
                  style: AppTextStyles.baseStyle,
                ),
                subtitle: Text(
                  "2.3Km  ",
                  style: AppTextStyles.smalltitle,
                ),
                trailing: const Text(
                  "₹60.00",
                  style: AppTextStyles.baseStyle,
                ),
              ),
            ),
            Container(
              width: ResponsiveSize.width(context, 340),
              height: ResponsiveSize.height(context, 39),
              color: AppColors.purplebackground,
              child: const ListTile(
                title: Text(
                  "Total",
                  style: AppTextStyles.baseStyle,
                ),
                trailing: Text(
                  "₹60.00",
                  style: AppTextStyles.baseStyle,
                ),
              ),
            ),
          ],
        ));
  }
}

class EContainer extends StatelessWidget {
  const EContainer({super.key, required this.color, this.child});
  final Color color;
  final child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ResponsiveSize.width(context, 340),
        height: ResponsiveSize.height(context, 54),
        decoration: BoxDecoration(
            color: color,
         ),
        child: child);
  }
}
