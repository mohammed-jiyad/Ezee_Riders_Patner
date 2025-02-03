import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/features/online/screens/online_state.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
class RideCancel extends StatefulWidget {
  const RideCancel({super.key});

  @override
  State<RideCancel> createState() => _RideCancelState();
}

class _RideCancelState extends State<RideCancel> {
  String? selectedReason;
  final List<String> reasons = [
    "Customer is not picking up the call",
    "Can’t find the customer",
    "Waiting time is too much",
    "Misbehaved ",
    "Other",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 400),
        child: Container(
          height: 500,width: 360,
          color:AppColors.backgroundColor,
          child: Column(children: [
             Padding(
               padding: const EdgeInsets.only(left: 12,top: 12),
               child: Text("Share the reason for cancelling the pickup",style: AppTextStyles.baseStyle.copyWith(fontSize: 20),),
             ),
           
            Expanded(
              child: ListView.builder(
                 itemCount: reasons.length,
                itemBuilder: (context, index) {
                return GestureDetector(
                  
                   onTap: (){
                    setState(() {
                      selectedReason=reasons[index];
                    });
                  
                      
                   },child: Padding(
                    padding: const EdgeInsets.only(left: 24,right: 24,bottom: 2,top: 2),
                     child: Container(
                      height: 40,width: 328,
                      
                      decoration: BoxDecoration(
                        color: selectedReason == reasons[index]
                          ? AppColors.greenbackground: AppColors.backgroundColor,
                        border: Border.all(
                          color:selectedReason == reasons[index]
                          ? AppColors.greenColor: AppColors.greytextColor,
                        
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(reasons[index],
                            style: AppTextStyles.baseStyle.copyWith(color: AppColors.greytextColor),),
                          ),
                        ],
                      ),
                     ),
                   ),
                   );
                   
              
                
              },),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 328,height: 48,
                
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))
                  ),
                  onPressed: (){
                  if(selectedReason!=null){
                    print("selected reaason:$selectedReason");
                  }else{
                    return;
                  }
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OnlineState()));
                }, child: Text("Submit Feedback",style: AppTextStyles.baseStyle.copyWith(color:AppColors.backgroundColor),)),
              ),
            )
            
          ],),
        ),
      ),
    );
  }
}