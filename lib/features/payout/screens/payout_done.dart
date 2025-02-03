import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/payout/screens/withdraw_info.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:uig/utils/responsive_size.dart';

class PayoutDone extends StatelessWidget {
  final int amount;
  const PayoutDone({super.key,required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor:  AppColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const SizedBox(
            height: 11.31,
            width: 6.71,
            child: Icon(
              Icons.arrow_back_ios,
              color:AppColors.blackColor
            ),
          ),
        ),
        title: Text(
          "Withdraw",
          style: AppTextStyles.baseStyle.copyWith(fontSize: 18.72),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: ResponsiveSize.height(context, 200)),
            child: Center(
              child: Container(
                height: ResponsiveSize.height(context, 100),
                width: ResponsiveSize.width(context, 100),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenColor
                ),
                child: const DecoratedIcon(
                  icon: Icon(
                    Icons.check,
                    color: AppColors.backgroundColor,
                    size: 54,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(
                      width: 10,
                      color: AppColors.backgroundColor
                    ),
                  ),
                ),
              ),
            ),
          ),
          RichText(
            text:  TextSpan(
              style: const TextStyle(
                color: AppColors.blacktextColor,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                  text: "₹ $amount",
                  style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600,fontSize: 24),
                ),
                TextSpan(
                  text: " cashed out \n       successfully!",
                  style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.w600,fontSize: 24),
                ),
              ],
            ),
          ),SizedBox(height: ResponsiveSize.height(context, 10),),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Withdrawn amount may take 2-3 business days "
              "\n                 to reflect on your bank account",
              style: AppTextStyles.smalltitle,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 20)),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => WithdrawInfo(amount: amount,)),
                // );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.primaryColor,
                minimumSize: Size(ResponsiveSize.width(context, 328), 48),
              ),
              child: const Text(
                "Done",
                style: TextStyle(fontSize: 18, color:AppColors.backgroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
