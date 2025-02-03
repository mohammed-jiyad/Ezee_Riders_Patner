
import 'app_colors.dart';
import 'bar_chart.dart';
import 'responsive_size.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<BarChartGroupData> barChartGroups(BuildContext context) {
  return [
    createBarChartGroupData(
      x: 1,
      toY: 0,
      width: ResponsiveSize.width(context, 24),
      color: AppColors.newColor,
    ),
    createBarChartGroupData(
      x: 2,
      toY: 477,
      width: ResponsiveSize.width(context, 24),
      color:  AppColors.newColor,
      barsSpace: ResponsiveSize.width(context, 10),
    ),
    createBarChartGroupData(
      x: 3,
      toY: 80,
      width: ResponsiveSize.width(context, 24),
      color:  AppColors.newColor,
      barsSpace: ResponsiveSize.width(context, 10),
    ),
    createBarChartGroupData(
      x: 4,
      toY: 400,
      width: ResponsiveSize.width(context, 24),
      color:  AppColors.newColor,
      barsSpace: ResponsiveSize.width(context, 10),
    ),
    createBarChartGroupData(
      x: 5,
      toY: 0,
      width: ResponsiveSize.width(context, 24),
      color:  AppColors.newColor,
      barsSpace: ResponsiveSize.width(context, 10),
    ),
    createBarChartGroupData(
      x: 6,
      toY: 0,
      width: ResponsiveSize.width(context, 24),
      color: AppColors.newColor,
      barsSpace: ResponsiveSize.width(context, 10),
    ),
  ];
}
