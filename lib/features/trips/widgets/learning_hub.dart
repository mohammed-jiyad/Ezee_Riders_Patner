import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LearningHub extends StatefulWidget {
  const LearningHub({super.key});

  @override
  State<LearningHub> createState() => _LearningHubState();
}

class _LearningHubState extends State<LearningHub> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( left: 20),
      child: SizedBox(
          height: ResponsiveSize.height(context, 248),
          width: ResponsiveSize.width(context, 360),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Learning Hub",
                style: AppTextStyles.headline,
              ),
             SizedBox(height:ResponsiveSize.height(context, 10),),
              SizedBox(
                height: ResponsiveSize.height(context, 143),
                child: PageView(
                  children: [
                    Container(
                      height: ResponsiveSize.height(context, 155),
                      width: ResponsiveSize.width(context, 253),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 17,
                                spreadRadius: 0,
                                offset: Offset(0, 4)),
                          ]),
                      child: Image.asset("assets/images/Learning_hub.png"),
                    ),
                    Container(
                      height: ResponsiveSize.height(context, 155),
                      width: ResponsiveSize.width(context, 253),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 17,
                                spreadRadius: 0,
                                offset: Offset(0, 4)),
                          ]),
                      child: Image.asset("assets/images/Learning_hub.png"),
                    ),
                      Container(
                      height: ResponsiveSize.height(context, 155),
                      width: ResponsiveSize.width(context, 253),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 17,
                                spreadRadius: 0,
                                offset: Offset(0, 4)),
                          ]),
                      child: Image.asset("assets/images/Learning_hub.png"),
                    ),
                  ],
                ),
              ),
               SizedBox(
                height: ResponsiveSize.height(context, 10),
              ),
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  effect: const WormEffect(
                      dotWidth: 6.0,
                      dotHeight: 6,
                      dotColor: AppColors.secondaryColor,
                      activeDotColor:AppColors.blacktextColor),
                  count: 3,
                  controller: pageController,
                ),
              )
            ],
          )),
    );
  }
}
