import 'package:uig/features/help/screens/payment_issue.dart';
import 'package:uig/features/help/screens/tickets.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:uig/features/help/screens/payment_issue.dart';


class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<Help> {
  final List<String>_help = [
 "Found an item in the ride",
  "Issue with the customer",
  "Payment issue",
  "I was involve in a accident",
  "Cash deposit issue ",
  "Vehicle Verification issue",
  "Vehicle Verification rejected",
  "Support tickets",
  "App issue"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,

        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 18,
              color: AppColors.blackColor,
            )),

      title:  Padding(
        padding: const EdgeInsets.only(right:10),
        child: SizedBox(
            height: ResponsiveSize.height(context,36),
            width: ResponsiveSize.width(context, 264),
            child: TextField(
              decoration: InputDecoration(
                fillColor: AppColors.newColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                hintText: "Search",
                hintStyle: AppTextStyles.smalltitle
              ),
            ),
          ),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
               padding: const EdgeInsets.only(left: 10),
              child: Text("Get Help",style: AppTextStyles.headline.copyWith(
                fontWeight: FontWeight.w600
              ),),
            ),
            const Padding(
           padding: EdgeInsets.only(left: 10),
              child: Text("What issue do you need help with?",style: AppTextStyles.baseStyle,),
            ),
            SizedBox(height:ResponsiveSize.height(context, 15)),
            Expanded(
                child: ListView.builder(
                    itemCount: _help.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_help[index] 
                         ,
                          style: AppTextStyles.baseStyle
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.blacktextColor,
                          size: 11,
                        ),
                        onTap: (){

                              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  PaymentIssue(value: _help[index]),
                    ),
                  );
                          if (index == 7) {
                            Navigator.pop(context);
                  // Navigate to Third Screen when the last option is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Tickets(),
                    ),
                  );
                } else {
                  // Optionally, handle taps on other indices
                  print('No action for this option');
                }
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
