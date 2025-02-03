import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSize.width(context, 314),
      height: ResponsiveSize.height(context, 136),
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 1,
                  barsSpace: ResponsiveSize.width(context, 5),
                  barRods: [
                    BarChartRodData(
                      toY: 477,
                      color: AppColors.newColor,
                      width: ResponsiveSize.width(context, 24),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ResponsiveSize.width(context, 4)),
                        topRight: Radius.circular(ResponsiveSize.width(context, 4)),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barsSpace: ResponsiveSize.width(context, 10),
                  barRods: [
                    BarChartRodData(
                      toY: 80,
                      color: AppColors.primaryColor,
                      width: ResponsiveSize.width(context, 24),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ResponsiveSize.width(context, 4)),
                        topRight: Radius.circular(ResponsiveSize.width(context, 4)),
                      ),
                    ),
                  ],
                ),
                for (int i = 3; i <= 7; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: ResponsiveSize.width(context, 10),
                    barRods: [
                      BarChartRodData(
                        toY: 0,
                        width: ResponsiveSize.width(context, 24),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ResponsiveSize.width(context, 4)),
                          topRight: Radius.circular(ResponsiveSize.width(context, 4)),
                        ),
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1:
                          return Text('Sep 17', style: AppTextStyles.chartstyle);
                        case 2:
                          return Text('Sep 17', style: AppTextStyles.chartstyle);
                        case 3:
                          return Text("18", style: AppTextStyles.chartstyle);
                        case 4:
                          return Text("19", style: AppTextStyles.chartstyle);
                        case 5:
                          return Text("20", style: AppTextStyles.chartstyle);
                        case 6:
                          return Text("21", style: AppTextStyles.chartstyle);
                        case 7:
                          return Text("22", style: AppTextStyles.chartstyle);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0xFF000000),
                    width: 1,
                  ),
                  right: BorderSide.none,
                  left: BorderSide.none,
                  top: BorderSide.none,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    for (int i = 0; i < 7; i++)
                      Positioned(
                        left: constraints.maxWidth * (0.02 + i * 0.15),
                        top: constraints.maxHeight * (i == 0 ? 0 : 0.7),
                        child: Text(
                          i == 0 ? "₹477" : i == 1 ? "₹80" : "₹0",
                          style: AppTextStyles.chartstyle.copyWith(
                            fontSize: 12
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
