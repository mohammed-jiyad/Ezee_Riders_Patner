
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class Benefit extends StatefulWidget {
 const Benefit({super.key});

  @override
  State<Benefit> createState() => _BenefitState();
}

class _BenefitState extends State<Benefit> {
    final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.only(left: 20,right: 20),
      child: Expanded(
        child: SizedBox(
          height: ResponsiveSize.height(context, 178), 
          width: ResponsiveSize.width(context, 360),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Benefit for you",style: AppTextStyles.headline,)),
                SizedBox(
                  height: ResponsiveSize.height(context, 100),
                  child: PageView(
                    
                    children: [
                     Padding(
                       padding:  EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 15),
                        vertical: ResponsiveSize.height(context, 17),
                       ),
                       child: Container(
                                         height: ResponsiveSize.height(context, 103),
                                         width:ResponsiveSize.width(context, 246),
                                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),color: const Color(0xFFFFFFFF),
                                        boxShadow: const [
                                     BoxShadow(
                                       color: AppColors.boxColor,
                                       blurRadius: 17,spreadRadius: 0,offset: Offset(0, 4)
                                     ),
                                           ]),
                                           child:
                                          ListTile(
                                            
                                           leading: Image.asset('assets/images/rupees.png'),
                                           title: const Text("Earn upto ₹100 by inviting",style: AppTextStyles.baseStyle,),
                                           
                                           subtitle: Text("Invite your friends to drive in Ezee Riders and earn ₹100.",
                            style: AppTextStyles.headline.copyWith(fontSize: 10.72),),
                                          )
                                       ),
                     ),
                 Padding(
                       padding:  EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 15),
                        vertical: ResponsiveSize.height(context, 17),
                       ),
                       child: Container(
                                         height: ResponsiveSize.height(context, 103),
                                         width:ResponsiveSize.width(context, 246),
                                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),color: const Color(0xFFFFFFFF),
                                        boxShadow: const [
                                     BoxShadow(
                                       color: AppColors.boxColor,
                                       blurRadius: 17,spreadRadius: 0,offset: Offset(0, 4)
                                     ),
                                           ]),
                                           child:
                                          ListTile(
                                            
                                           leading: Image.asset('assets/images/rupees.png'),
                                           title: const Text("Earn upto ₹100 by inviting",style: AppTextStyles.baseStyle,),
                                           
                                           subtitle: Text("Invite your friends to drive in Ezee Riders and earn ₹100.",
                            style: AppTextStyles.headline.copyWith(fontSize: 10.72),),
                                          )
                                       ),
                     ),
                 Padding(
                       padding:  EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 15),
                        vertical: ResponsiveSize.height(context, 17),
                       ),
                       child: Container(
                                         height: ResponsiveSize.height(context, 103),
                                         width:ResponsiveSize.width(context, 246),
                                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),color: const Color(0xFFFFFFFF),
                                        boxShadow: const [
                                     BoxShadow(
                                       color: AppColors.boxColor,
                                       blurRadius: 17,spreadRadius: 0,offset: Offset(0, 4)
                                     ),
                                           ]),
                                           child:
                                          ListTile(
                                            
                                           leading: Image.asset('assets/images/rupees.png'),
                                           title: const Text("Earn upto ₹100 by inviting",style: AppTextStyles.baseStyle,),
                                           
                                           subtitle: Text("Invite your friends to drive in Ezee Riders and earn ₹100.",
                            style: AppTextStyles.headline.copyWith(fontSize: 10.72),),
                                          )
                                       ),
                     ),
                  ],),
                ),
                
               SizedBox(
                height: ResponsiveSize.height(context, 5)
              ),
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  effect: const WormEffect(
                      dotWidth: 6.0,
                      dotHeight: 6,
                      dotColor: AppColors.secondaryColor,
                      activeDotColor: AppColors.blacktextColor),
                  count: 3,
                  controller: pageController,
                ),
              )

               
            ],
          ),
        ),
      ),
    );
  }
}