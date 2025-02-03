import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/responsive_size.dart'; // Import ResponsiveSize class

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset("assets/images/Ganesh.png",
                height:ResponsiveSize.height(context, 100), 
                width:  ResponsiveSize.width(context, 100),),
                Text(
                  "Ganesh Mahanta",
                  style: AppTextStyles.headline3.copyWith(color: AppColors.newtextColor,
                  fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 68)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.volume_up, color: AppColors.blackColor),
                ),
                Container(
                  height: ResponsiveSize.height(context, 60), 
                  width: ResponsiveSize.width(context, 60), 
                  decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                    color:AppColors.redColor
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call_end, color: AppColors.backgroundColor),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic, color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
