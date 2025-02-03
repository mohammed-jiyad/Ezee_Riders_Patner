
import 'app_colors.dart';
import 'package:flutter/material.dart';
class CircleContainer extends StatelessWidget {
  const CircleContainer({super.key, required this.height, required this.width, required this.child});
 final  double height;
 final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      
            decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color:AppColors.newColor
      ),
      
    );
  }
}