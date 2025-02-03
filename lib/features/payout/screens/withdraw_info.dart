import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/explore/widgets/time_line.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:uig/utils/responsive_size.dart';

class WithdrawInfo extends StatelessWidget {
  final int amount;
  const WithdrawInfo({super.key,required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor:AppColors.backgroundColor,
        leading: InkWell(
            onTap:(){
              Navigator.of(context).pop();
            }
            ,child: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: ResponsiveSize.height(context, 21), left: ResponsiveSize.width(context, 13)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: ResponsiveSize.height(context, 40),
              width: ResponsiveSize.width(context, 40),
              decoration: const BoxDecoration(
                  color:AppColors.greenColor, shape: BoxShape.circle),
              child: const SizedBox(
                height: 13.5,
                width: 20.26,
                child: DecoratedIcon(
                  icon: Icon(
                    Icons.check,
                    color: AppColors.backgroundColor
                  ),
                  decoration: IconDecoration(
                      border: IconBorder(width: 2, color:AppColors.backgroundColor)),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 10)),
            RichText(
              text:  TextSpan(
                style: const TextStyle(color: AppColors.blacktextColor, fontSize: 24),
                children: [
                  TextSpan(
                      text: "₹", style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " $amount",
                      style:  AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600))
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 5)),
            const Text(
              "Withdraw successful",
              style: AppTextStyles.baseStyle,
            ),
            Text("To BANK OF INDIA XXXX 1234", style: AppTextStyles.smalltitle),
            SizedBox(height: ResponsiveSize.height(context, 20)),
            const Text(
              "Status",
              style: AppTextStyles.baseStyle,
            ),
             TimeLineWidgetnew(
              isfirst: true,
              islast: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 17, left: 17),
                child: Text(
                  "14 Sep 2024, 10:42 AM "
                  "\ntxn ID 123456fd6789900099888",
                  style:AppTextStyles.smalltitle,
                ),
              ),
            ),
          TimeLineWidgetnew(
              isfirst: false,
              islast: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 17, left: 17),
                child: Text(
                  "Transfer initiated to your bank "
                  "\n14 Sep 2024, 9:42 PM",
                  style:AppTextStyles.smalltitle,
                ),
              ),
            ),
             TimeLineWidgetnew(
              isfirst: false,
              islast: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 17, left: 17),
                child: Text(
                  "Amount deposited in your bank"
                  "\n16 Sep 2024, 9:42 AM"
                  "\nUTR No. CMS7830837658",
                  style:AppTextStyles.smalltitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
