import 'package:flutter/material.dart';
class ResponsiveSize{
 static double screenHeight(BuildContext context)=> MediaQuery.of(context).size.height;
 static double screenWidth(BuildContext context)=> MediaQuery.of(context).size.width;

 static double height(BuildContext context,double value)=>
     (value/800)*screenHeight(context);
 static double width(BuildContext context,double value)=>
     (value/360)*screenWidth(context);
}