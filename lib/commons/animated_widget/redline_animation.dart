
import 'package:flutter/material.dart';
class RedLineAnimation extends StatefulWidget {
  const RedLineAnimation({super.key});

  @override
  State<RedLineAnimation> createState() => _RedLineAnimationState();
}

class _RedLineAnimationState extends State<RedLineAnimation> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this)..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 320).animate(_controller);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return  Stack(children: [Container(width: 320,height: 3,color: const Color(0xFFD9D9D9),),
         AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          left: _animation.value,
          child:  Container(
        height: 3,
        width: 56,
        color: Colors.red,
      ),);
        },
      
    )
    ],);
   
   
  }
}