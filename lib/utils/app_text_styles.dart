
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle baseStyle = TextStyle(
    fontFamily: 'ProductSans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Color(0xFF221E22),
  );
  static const TextStyle baseStyle2 = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get headline => baseStyle.copyWith(
    fontSize: 18.72,fontWeight: FontWeight.w700
  );
  static TextStyle get headline2 => baseStyle.copyWith(
    fontSize: 18,fontWeight: FontWeight.w500,color: const Color(0xFF24A665)
  );
  
  static TextStyle get headline3 => baseStyle.copyWith(
    fontSize: 18,fontWeight: FontWeight.w500,color: const Color(0xFFE75356)
  );

   static TextStyle get title => baseStyle.copyWith(
    fontWeight: FontWeight.w600,fontSize: 14
   );
  static TextStyle get subtitle => baseStyle.copyWith(
    fontSize: 10,fontWeight: FontWeight.w400,color: const Color(0xFF818587)
  );
  static TextStyle get smalltitle => baseStyle.copyWith(
    fontSize: 13.28,fontWeight: FontWeight.w400,color: const Color(0xFF818587)
  );
  static TextStyle get chartstyle => baseStyle2.copyWith(
    fontSize: 8,color: const Color(0xFF818587),fontWeight: FontWeight.w500
  );
}