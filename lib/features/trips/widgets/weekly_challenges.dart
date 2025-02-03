import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WeeklyChallenges extends StatefulWidget {
  const WeeklyChallenges({super.key});

  @override
  State<WeeklyChallenges> createState() => _WeeklyChallengesState();
}

class _WeeklyChallengesState extends State<WeeklyChallenges> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: SizedBox(
        height: ResponsiveSize.height(context, 213),
        width:ResponsiveSize.width(context, 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("  Weekly Challenges", style: AppTextStyles.headline),
           
            SizedBox( 
              height: ResponsiveSize.height(context, 145),
              child: PageView(
                children: [
                  Padding(
                    padding:EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 9),
                        vertical: ResponsiveSize.height(context, 18),
                       ),
                    child: Container(
                      width: ResponsiveSize.width(context, 311),
                      height: ResponsiveSize.height(context, 123),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.backgroundColor,
                          border: Border.all(
                            color: AppColors.boxColor,
                            width: 1
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 17,
                                spreadRadius: 0,
                                offset: Offset(0, 4))
                          ]),
                      child: Padding(
                        padding:  const EdgeInsets.only(top: 9,bottom: 9,right: 18,left: 18),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ends on 16 Sep 2024",
                                    style: AppTextStyles.baseStyle.copyWith(
                                        fontSize: 10.72,
                                        fontWeight: FontWeight.w700)),
                                 SizedBox(
                                  height: ResponsiveSize.height(context, 5),
                                ),
                                const Text("Complete 20 trips and \n ₹100 extra",
                                    style: AppTextStyles.baseStyle),
                                 SizedBox(
                                  height:ResponsiveSize.height(context, 10),
                                ),
                                const Text("2/20 trips done",
                                    style: TextStyle(
                                        fontFamily: 'ProductSans',
                                        fontSize: 10,
                                        color: AppColors.blacktextColor))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ), Padding(
                     padding:EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 9),
                        vertical: ResponsiveSize.height(context, 18),
                       ),
                    child: Container(
                          width: ResponsiveSize.width(context, 311),
                      height: ResponsiveSize.height(context, 123),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                            color: AppColors.boxColor,
                            width: 1
                          ),
                          color: AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 17,
                                spreadRadius: 0,
                                offset: Offset(0, 4))
                          ]),
                      child: Padding(
                          padding:  const EdgeInsets.only(top: 9,bottom: 9,right: 18,left: 18),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ends on 16 Sep 2024",
                                      style: AppTextStyles.baseStyle.copyWith(
                                          fontSize: 10.72,
                                          fontWeight: FontWeight.w700)),
                                   SizedBox(
                                    height: ResponsiveSize.height(context, 5),
                                  ),
                                  const Text("Complete 20 trips and \n ₹100 extra",
                                      style: AppTextStyles.baseStyle),
                                   SizedBox(
                                    height:ResponsiveSize.height(context, 10),
                                  ),
                                  const Text("2/20 trips done",
                                      style: TextStyle(
                                          fontFamily: 'ProductSans',
                                          fontSize: 10,
                                          color: AppColors.blacktextColor))
                                ],
                              )
                            ],
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  effect: const WormEffect(
                      dotWidth: 6.0,
                      dotHeight: 6,
                      dotColor:AppColors.secondaryColor,
                      activeDotColor: AppColors.blacktextColor),
                  count: 3,
                  controller: pageController,
                ),
              )
          ],
        ),
      ),
    );
  }
}
