import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:uig/features/help/screens/help_screen.dart';
import 'package:uig/features/help/screens/tickets.dart';
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(context, 360),
      height:ResponsiveSize.height(context, 353),
      
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
       borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
              topRight:  Radius.circular(12),
       ),
      
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
           Container(
             height: ResponsiveSize.height(context, 42),
             width: ResponsiveSize.width(context, 360),
             decoration: const BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   width: 1,color: AppColors.helpIconColor,
                   
                 )
               )
             ),
             child: const Padding(
               padding:  EdgeInsets.only(left:15,top: 20),
               child: Text(
                 "How can we help?",
                 style: AppTextStyles.baseStyle),
             ),
           ),
          
          Container(
             height: ResponsiveSize.height(context, 61),
             width: ResponsiveSize.width(context, 360),
             decoration: const BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   width: 1,color: AppColors.helpIconColor,
                   
                 )
               )
             ),
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -2),
              leading: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryColor,
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.primaryColor,
                  )),
              title: const Text(
                'Help Centre',
                style: AppTextStyles.baseStyle
              ),
              subtitle:  Text(
                'Find answers to your queries and raise tickets',
                style: AppTextStyles.subtitle
              ),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Help()));
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )),
            ),
          ),
          Container(
             height: ResponsiveSize.height(context, 61),
             width: ResponsiveSize.width(context, 360),
             decoration: const BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   width: 1,color: AppColors.helpIconColor,
                   
                 )
               )
             ),
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -2),
              leading: Container(
                  width: ResponsiveSize.width(context, 28),
                  height: ResponsiveSize.height(context, 28),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:  AppColors.secondaryColor,
                  ),
                  child: const Icon(
                    Icons.confirmation_num_outlined,
                    color: AppColors.primaryColor,
                  )),
              title: const Text(
                'Support Tickets',
                style: AppTextStyles.baseStyle
              ),
              subtitle:  Text(
                'Check status of tickets raised',
                style: AppTextStyles.subtitle
              ),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Tickets()));
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )),
            ),
          ),
          Container(
            height: ResponsiveSize.height(context, 60),
             width: ResponsiveSize.width(context, 360),
             decoration: const BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   width: 1,color: AppColors.secondaryColor,
                   
                 )
               )
             ),
            child: ListTile(
              
                leading: Container(
                    width: ResponsiveSize.width(context, 28),
                    height: ResponsiveSize.height(context, 28),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.helpIconColor
                    ),
                    child: const Icon(
                      Icons.language,
                      color: Color(0xFFC8C8C8),
                    )),
                title: Row(
                  children: [
                    const Text(
                      'Change Language',
                      style:AppTextStyles.baseStyle,
                    ),
                   SizedBox(
                      width: ResponsiveSize.width(context, 6),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: ResponsiveSize.height(context, 21),
                        width:  ResponsiveSize.width(context, 90),
                        child: Container(
                            decoration: const BoxDecoration(color:AppColors.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                            child:  Align(
                              alignment: Alignment.center,
                              child: Text(
                                'COMING SOON',
                                
                                style: AppTextStyles.subtitle.copyWith(color: AppColors.backgroundColor,fontWeight: FontWeight.w500)
                              ),
                            )),
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.chevron_right))),
          ),
          Container(
            height: ResponsiveSize.height(context, 61),
             width: ResponsiveSize.width(context, 360),
             decoration: const BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   width: 1,color: AppColors.secondaryColor,
                   
                 )
               )
             ),
            child: ListTile(
                leading: Container(
                    width:  ResponsiveSize.width(context, 28),
                    height:  ResponsiveSize.height(context, 28),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.helpIconColor,
                    ),
                    child: const Icon(
                      Icons.cloudy_snowing,
                      color:  Color(0xFFC8C8C8),
                    )),
                title: Row(
                  children: [
                    const Text(
                      'Report Rain',
                      style: AppTextStyles.baseStyle,
                    ),
                     SizedBox(
                      width:  ResponsiveSize.width(context, 48),
                    ),
                    Expanded(
                      child: SizedBox(
                        height:  ResponsiveSize.height(context, 21),
                        width:  ResponsiveSize.width(context, 90),
                        child: Container(
                            decoration: const BoxDecoration(color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'COMING SOON',
                                                         
                                style: AppTextStyles.subtitle.copyWith(color: AppColors.backgroundColor,fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.chevron_right))),
          )
        ],
      ),
    );
  }
}
