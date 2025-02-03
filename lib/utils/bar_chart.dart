import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartGroupData createBarChartGroupData({
  required int x,
  required double toY,
  required double width,
  required Color color,
  double barsSpace = 0,
}) {
  return BarChartGroupData(
    x: x,
    barsSpace: barsSpace,
    barRods: [
      BarChartRodData(
        toY: toY,
        width: width,
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    ],
  );
}

