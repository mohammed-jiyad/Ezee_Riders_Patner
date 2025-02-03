import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:uig/features/payout/widgets/select_option.dart';
import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  void _selectOption(BuildContext context){
    showModalBottomSheet(context: context,
    
     builder: (context){
      return const SelectOptionPage();
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        // width: 360,
        // height: 374,
         decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
         borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
                topRight:  Radius.circular(12),
         ),
        
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13, top: 3),
          child: Column(
            children: [
            Center(
              child: Padding(
                padding:  EdgeInsets.only(top: ResponsiveSize.height(context, 5)),
                child: Container(
                  width: ResponsiveSize.width(context, 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: const Divider(
                    thickness: 2,
                    endIndent: 2,
                    indent: 2,
                    height: 3.5,
                  ),
                ),
              ),
            ),
              SizedBox(
                height: ResponsiveSize.height(context, 10),
              ),
             //  Align(
             //    alignment: Alignment.topLeft,
             //    child: Padding(
             //      padding: const EdgeInsets.only(left: 13),
             //      child: Text(
             //        "Payout details: ",
             //        style: AppTextStyles.baseStyle2.copyWith(
             //          color: AppColors.blacktextColor,
             //        ),
             //      ),
             //    ),
             //  ),
             //  Container(
             //    height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //    decoration: const BoxDecoration(
             //      border: Border(
             //        bottom: BorderSide(
             //          width: 1,color: AppColors.newColor
             //        )
             //      )
             //    ),
             //    child: Center(
             //      child: ListTile(
             //       visualDensity: const VisualDensity(vertical: -4),
             //        title: Text(
             //          "Earnings",
             //          style: AppTextStyles.baseStyle2
             //              .copyWith(color: AppColors.greytextColor,
             //              fontWeight: FontWeight.w600),
             //        ),
             //        trailing: Text(
             //          "₹470.57",
             //          style: AppTextStyles.baseStyle2
             //              .copyWith(color:AppColors.blacktextColor,
             //              fontWeight: FontWeight.w600),
             //        ),
             //      ),
             //    ),
             //  ),
             //  Container(
             //      height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //    decoration: const BoxDecoration(
             //      border: Border(
             //        bottom: BorderSide(
             //          width: 1,color: AppColors.newColor
             //        )
             //      )
             //    ),
             //    child: ListTile(
             //          visualDensity: const VisualDensity(vertical: -4),
             //      title: Text(
             //        "Cash in hand",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color:AppColors.greytextColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //      trailing: Text(
             //        "₹340.42",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color: AppColors.redColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //    ),
             //  ),
             //  Container(
             //     height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //    decoration: const BoxDecoration(
             //      border: Border(
             //        bottom: BorderSide(
             //          width: 1,color: AppColors.newColor
             //        )
             //      )
             //    ),
             //    child: ListTile(
             //          visualDensity: const VisualDensity(vertical: -4),
             //      title: Text(
             //        "Deductions",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color:AppColors.greytextColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //      trailing: Text(
             //        "₹0",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color:AppColors.redColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //    ),
             //  ),
             //  Container(
             //     height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //    decoration: const BoxDecoration(
             //      border: Border(
             //        bottom: BorderSide(
             //          width: 1,color: AppColors.newColor
             //        )
             //      )
             //    ),
             //    child: ListTile(
             //           visualDensity: const VisualDensity(vertical: -4),
             //      title: Text(
             //        "Amount withdrawn",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color: AppColors.greytextColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //      trailing: Text(
             //        "₹0",
             //        style: AppTextStyles.baseStyle2
             //            .copyWith(color: AppColors.redColor,
             //            fontWeight: FontWeight.w600),
             //      ),
             //    ),
             //  ),
             //
             //  SizedBox(
             //     height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //
             //    child: ListTile(
             //
             //      title: Text(
             //        "Payout balance",
             //        style: AppTextStyles.baseStyle2.copyWith(
             //            color: const Color(0xFF221E22),
             //            fontSize: 16,
             //            fontWeight: FontWeight.w600),
             //      ),
             //      trailing: Text(
             //        "₹62.80",
             //        style: AppTextStyles.baseStyle2.copyWith(
             //            color: AppColors.blacktextColor,
             //            fontSize: 16,
             //            fontWeight: FontWeight.w600),
             //      ),
             //    ),
             //  ),
             //  Padding(
             //     padding: const EdgeInsets.only(left: 18,right: 30,top: 18),
             //     child: SizedBox(
             //       height: ResponsiveSize.height(context, 36),
             //    width: ResponsiveSize.width(context, 360),
             //       child: Row(
             //          mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //          children: [
             //            Text(
             //              "Min. balance required "
             //              "\nThis amount will be adjusted with \nthe weekly payout",
             //              style: AppTextStyles.baseStyle2.copyWith(
             //                  color: AppColors.greytextColor,
             //                  fontSize: 10,
             //                  fontWeight: FontWeight.w500),
             //            ),
             //            Text(
             //              "₹300",
             //              style: AppTextStyles.baseStyle2.copyWith(
             //                  color: AppColors.greytextColor,
             //                  fontSize: 14,
             //                  fontWeight: FontWeight.w500),
             //            )
             //          ],
             //        ),
             //     ),
             //   ),
             //   SizedBox(
             // height: ResponsiveSize.height(context, 30),
             //    width: ResponsiveSize.width(context, 360),
             //
             //     child: ListTile(
             //           visualDensity: const VisualDensity(vertical: -4),
             //      title: Text(
             //        "Withdrawable amount ",
             //        style: AppTextStyles.baseStyle2.copyWith(
             //            color: AppColors.blacktextColor,
             //            fontSize: 16,
             //            fontWeight: FontWeight.w600),
             //      ),
             //      trailing: Text(
             //        "₹0",
             //        style: AppTextStyles.baseStyle2.copyWith(
             //            color:  AppColors.blacktextColor,
             //            fontSize: 16,
             //            fontWeight: FontWeight.w600),
             //      ),
             //                 ),
             //   ),SizedBox(   height: ResponsiveSize.height(context, 5),),
              SizedBox(
                width: ResponsiveSize.width(context, 320),
                height: ResponsiveSize.height(context, 38),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greytextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  onPressed: (){
                    _selectOption(context);
                  }, 
                  child: Text(
                    "Withdraw",
                    style: AppTextStyles.baseStyle2.copyWith(
                      color: AppColors.backgroundColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
