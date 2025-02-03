import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class PayoutDetails extends StatefulWidget {
  const PayoutDetails({super.key});

  @override
  State<PayoutDetails> createState() => _PayoutDetailsState();
}

class _PayoutDetailsState extends State<PayoutDetails> {
  var items = [
    "sep17",
  ];
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
                  color: AppColors.blackColor
                ))),
        title: Text(
          "Payout Details",
          style: AppTextStyles.baseStyle.copyWith(fontSize: 18.72,fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
                 width: ResponsiveSize.width(context, 360),height: ResponsiveSize.height(context, 32),
            color: AppColors.purplebackground,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "16 sep to 22 sep",
                        style: AppTextStyles.baseStyle
                            .copyWith(color: AppColors.primaryColor, fontSize: 10.72),
                      ),
                      DropdownButton(
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: null,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color:  AppColors.primaryColor
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "All Trips",
                        style: AppTextStyles.baseStyle
                            .copyWith(color:  AppColors.primaryColor, fontSize: 10.72),
                      ),
                           DropdownButton(
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: null,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color:  AppColors.primaryColor,
                          ))
                    
                    ],
                  )
                ],
              ),
            ),
          ),SizedBox(height: ResponsiveSize.height(context, 20),),
          Container(
            width: ResponsiveSize.width(context, 360),height: ResponsiveSize.height(context, 40),
            color: AppColors.purplebackground,
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                                  "Sat, 18 Sep",
                                  style: AppTextStyles.baseStyle
                                      .copyWith(color: AppColors.primaryColor, fontSize: 13.28),
                                ),
                    ],
                  ),
                ],
              ),
            ),
          ),
           ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor
                            ),
                            child: const Icon(Icons.two_wheeler,color: AppColors.backgroundColor,)),
                          title: const Text("Ride to Cafe",style: AppTextStyles.baseStyle,),
                          subtitle: Text("1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹80",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              Transform.rotate(angle: 110,
                              child: const Icon(Icons.arrow_outward,size: 17.33,color:AppColors.greenColor,))
                            ],
                          ),
                        ),
                        ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.greenColor
                            ),
                            child: const Icon(Icons.payments,color: AppColors.backgroundColor,)),
                          title: const Text("Withdrawn",style: AppTextStyles.baseStyle,),
                          subtitle: Text("Bank account ending with **** 1234\n1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹350",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              const Icon(Icons.arrow_outward,size: 17.33,color: AppColors.redColor,)
                            ],
                          ),
                        ),  ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor
                            ),
                            child: const Icon(Icons.two_wheeler,color: AppColors.backgroundColor,)),
                          title: const Text("Ride to Cafe",style: AppTextStyles.baseStyle,),
                          subtitle: Text("1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹80",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              Transform.rotate(angle: 110,
                              child: const Icon(Icons.arrow_outward,size: 17.33,color:AppColors.greenColor,))
                            ],
                          ),
                        ),  ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor
                            ),
                            child: const Icon(Icons.two_wheeler,color:AppColors.backgroundColor,)),
                          title: const Text("Ride to Cafe",style: AppTextStyles.baseStyle,),
                          subtitle: Text("1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹80",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              Transform.rotate(angle: 110,
                              child: const Icon(Icons.arrow_outward,size: 17.33,color: AppColors.greenColor,))
                            ],
                          ),
                        ),  ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color:AppColors.greenColor
                            ),
                            child: const Icon(Icons.payments,color:AppColors.backgroundColor,)),
                          title: const Text("Withdrawn",style: AppTextStyles.baseStyle,),
                          subtitle: Text("Bank account ending with **** 1234\n1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹350",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              const Icon(Icons.arrow_outward,size: 17.33,color: AppColors.redColor,)
                            ],
                          ),
                        ), ListTile(
          
                          leading: Container(
                            height: 28,width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color:AppColors.redColor
                            ),
                            child: const Icon(Icons.currency_rupee,color: AppColors.backgroundColor,)),
                          title: const Text("Cash in Hand",style: AppTextStyles.baseStyle,),
                          subtitle: Text("1:09",style: AppTextStyles.smalltitle.copyWith(fontSize: 10.72),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹80",style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                              const SizedBox(width: 8,),
                              Transform.rotate(angle: 110,
                              child: const Icon(Icons.arrow_outward,size: 17.33,color: AppColors.greenColor,))
                            ],
                          ),
                        ),  
          
        ],
      ),
    );
  }
}
