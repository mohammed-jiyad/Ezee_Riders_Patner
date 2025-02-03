import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/payout/screens/withdraw_cash.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/responsive_size.dart';

class SelectOptionPage extends StatelessWidget {
  const SelectOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSize.height(context, 300),
      width: ResponsiveSize.width(context, 360),
      decoration: const BoxDecoration(
        color:AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),

        )
      ),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 3.5,
              width: 40,
              child: Divider(
                thickness: 2,
                endIndent: 2,
                indent: 2,
              ),
            ),
            SizedBox(
              height: ResponsiveSize.height(context, 5),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text(
                  "Select an option",
                  style: AppTextStyles.baseStyle2.copyWith(
                    color: AppColors.blacktextColor,
                  ),
                ),
              ),
            ),
            _buildOptionCard(context, "Pay by UPI"),
            _buildOptionCard(context, "Pay by debit card / Netbanking"),
            _buildOptionCard(context, "Deposit at Reliance store"),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String optionText) {
    return Card(
      borderOnForeground: true,
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color:AppColors.secondaryColor
        ),
      ),
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            optionText,
            style: AppTextStyles.baseStyle2.copyWith(
              color:AppColors.greytextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WithdrawCash()),
              );
            },
            icon: const SizedBox(
              width: 6.02,
              height: 10.68,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
                color: AppColors.blackColor
              ),
            ),
          ),
        ],
      ),
    );
  }
}
