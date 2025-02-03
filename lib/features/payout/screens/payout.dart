import 'package:uig/features/payout/screens/withdraw_cash.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/payout/widgets/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/responsive_size.dart'; // Import ResponsiveSize class
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
class PayOutScreen extends StatefulWidget {
  const PayOutScreen({super.key});

  @override
  State<PayOutScreen> createState() => _PayOutScreenState();
}

class _PayOutScreenState extends State<PayOutScreen> {
  @override
  void initState() {
    super.initState();
    Waiting();
  }
  double withdraw=0;
  String? phone_number;
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number: $phone_number'); // Print for debugging
  }
  void Waiting() async{
    await _getPhoneNumber();
    await withdrawfetchUser(phone_number);

  }
  Future<void> withdrawfetchUser(String? phonenumber) async {
    final response = await http.get(Uri.parse('${server.link}/withdrawfindUser/$phonenumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        withdraw = (data['balance'] is int) ? (data['balance'] as int).toDouble() : data['balance'];
      });

      print(withdraw);
    } else if (response.statusCode == 404) {
      print('User not found');
      setState(() {
        withdraw=0.0;
      });
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  // void _showWithdrawPage(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //
  //     builder: (context) {
  //       return const WithdrawPage();
  //     },
  //   );
  // }
  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const HelpScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:    AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: AppColors.backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 12),
              vertical: ResponsiveSize.height(context, 12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 29),
              child: SizedBox(
                width: ResponsiveSize.width(context, 360),
                height: ResponsiveSize.height(context, 51),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child: InkWell(
                                onTap: () => _showHelpPage(context),
                                child:
                                const Icon(Icons.help_outline_rounded)),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child:
                            const Icon(Icons.notifications_none_outlined),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 2.5),
                              right: ResponsiveSize.width(context, 2.5),
                            ),
                            child: const Icon(
                              Icons.warning_amber,
                              color: AppColors.redColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 12)),
            child: Container(
              height: ResponsiveSize.height(context, 168),
              width: ResponsiveSize.width(context, 324),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,color: AppColors.newColor
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.backgroundColor
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveSize.height(context, 20),
                  left: ResponsiveSize.width(context, 18),
                  right: ResponsiveSize.width(context, 7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Balance",
                          style: AppTextStyles.baseStyle2.copyWith(
                            color: AppColors.blacktextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "₹$withdraw",
                          style: AppTextStyles.baseStyle2.copyWith(
                            color: AppColors.blacktextColor,
                            fontWeight: FontWeight.w600,
                            
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Available cash limit: ₹$withdraw",
                      style: AppTextStyles.baseStyle2.copyWith(
                        color: AppColors.blacktextColor,
                        fontSize: 10,fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 10)),
                    const Divider(
                      height: 1,
                      color: AppColors.greytextColor,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Withdrawable amount",
                          style: AppTextStyles.baseStyle2.copyWith(
                            color: const Color(0xFF221E22),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "₹$withdraw",
                          style: AppTextStyles.baseStyle2.copyWith(
                            color: AppColors.blacktextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 5)),
                    SizedBox(
                      width: ResponsiveSize.width(context, 90),
                      height: ResponsiveSize.height(context, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "View details",
                            style: AppTextStyles.baseStyle2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.greenColor,
                              fontSize: 10,
                            ),
                          ),
                          Container(
                            width: ResponsiveSize.width(context, 13),
                            height: ResponsiveSize.height(context, 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.greenColor,
                            ),
                            child: const Icon(
                              Icons.arrow_right_alt,
                              size: 9,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   width: ResponsiveSize.width(context, 144),
                        //   height: ResponsiveSize.height(context, 34),
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.greenColor,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     onPressed: () {},
                        //     child: Text(
                        //       "Deposit",
                        //       style: AppTextStyles.baseStyle2.copyWith(
                        //         fontWeight: FontWeight.w600,
                        //         color: AppColors.backgroundColor,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: ResponsiveSize.width(context, 288),
                          height: ResponsiveSize.height(context, 34),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greytextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WithdrawCash()));
                            },
                            child: Text(
                              "Withdraw",
                              style: AppTextStyles.baseStyle2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 14)),
        ],
      ),
    );
  }
}
