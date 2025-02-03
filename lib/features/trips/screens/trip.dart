import 'package:uig/features/trips/widgets/benefit.dart';
import 'package:uig/features/trips/widgets/help_and_support.dart';
import 'package:uig/features/trips/widgets/learning_hub.dart';
import 'package:uig/features/trips/widgets/ride_requests.dart';
import 'package:uig/features/trips/widgets/weekly_challenges.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:uig/features/online/widgets/help_widget.dart';
class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const HelpScreen();
        });
  }
  @override
  Widget build(BuildContext context) {
     return Center(child: Container(child: Text('Coming Soon'),));
    // Scaffold(
    //     backgroundColor: AppColors.backgroundColor,
    //     appBar:    AppBar(
    //       automaticallyImplyLeading: false,
    //       flexibleSpace: Container(
    //         color: AppColors.backgroundColor,
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: ResponsiveSize.width(context, 12),
    //             vertical: ResponsiveSize.height(context, 12),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.only(top: 29),
    //             child: SizedBox(
    //               width: ResponsiveSize.width(context, 360),
    //               height: ResponsiveSize.height(context, 51),
    //               child: Row(
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       SizedBox(
    //                         height: ResponsiveSize.height(context, 19),
    //                         child: Padding(
    //                           padding: EdgeInsets.only(
    //                             left: ResponsiveSize.width(context, 2.5),
    //                             right: ResponsiveSize.width(context, 2.5),
    //                           ),
    //                           child: InkWell(
    //                               onTap: () => _showHelpPage(context),
    //                               child:
    //                               const Icon(Icons.help_outline_rounded)),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: ResponsiveSize.height(context, 19),
    //                         child: Padding(
    //                           padding: EdgeInsets.only(
    //                             left: ResponsiveSize.width(context, 2.5),
    //                             right: ResponsiveSize.width(context, 2.5),
    //                           ),
    //                           child:
    //                           const Icon(Icons.notifications_none_outlined),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: ResponsiveSize.height(context, 19),
    //                         child: Padding(
    //                           padding: EdgeInsets.only(
    //                             left: ResponsiveSize.width(context, 2.5),
    //                             right: ResponsiveSize.width(context, 2.5),
    //                           ),
    //                           child: const Icon(
    //                             Icons.warning_amber,
    //                             color: AppColors.redColor,
    //                           ),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     body: SingleChildScrollView(
    //   child: Container(
    //     color: AppColors.backgroundColor,
    //     padding: const EdgeInsets.only(top: 40),
    //     child: const Column(
    //       children: [
    //         RideRequests(),
    //         WeeklyChallenges(),
    //         Benefit(),
    //         LearningHub(),
    //         HelpAndSupport(),
    //       ],
    //     ),
    //   ),
    // )
    // );
  }
}
