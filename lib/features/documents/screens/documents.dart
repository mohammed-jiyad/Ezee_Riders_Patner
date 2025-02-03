import 'package:uig/features/documents/screens/driving_license.dart';
import 'package:uig/features/documents/screens/identify_verification.dart';
import 'package:uig/features/documents/screens/vehicle_insurance.dart';
import 'package:uig/features/documents/screens/vehicle_rc.dart';
import 'package:uig/features/documents/widgets/driver_box.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

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
              Icons.arrow_back_ios,
              size: 18,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Documents",
                style: AppTextStyles.headline,
              ),
              SizedBox(
                height: ResponsiveSize.height(context, 10),
              ),
              const Text(
                "Drivers Documents",
                style: AppTextStyles.baseStyle,
              ),
              DriverBox(title: "Driving License",
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                const DrivingLicense()
                ));
              },),

              DriverBox(title: "Identity Verification",
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                const IdentifyVerification()
                ));
              },),
              const SizedBox(height: 10,),
              const Text("Bajaj Pulsar 150",style: AppTextStyles.baseStyle,),
               const SizedBox(height: 10,),
               DriverBox(title: "Vehicle RC", onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                VehicleRc()
                ));
              }),
             // DriverBox(title: "Vehicle Insurance",
             //   onTap: (){
             //    Navigator.push(context, MaterialPageRoute(builder: (context)=>
             //    const VehicleInsurance()
             //    ));
             //  }),
               const SizedBox(height: 10,),


            ],
          ),
        ),
      ),
    );
  }
}
