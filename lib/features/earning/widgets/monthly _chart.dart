import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/bar_data_list.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:uig/utils/serverlink.dart';
class MonthlyChart extends StatefulWidget{
  const MonthlyChart({super.key});

  @override
  State<MonthlyChart> createState()=> _MonthlyChart();

}
class _MonthlyChart extends State<MonthlyChart> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: ResponsiveSize.width(context, 314), 
          height: ResponsiveSize.height(context, 136), 
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: barChartGroups(context),
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
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('1-1 sep', style: AppTextStyles.chartstyle),
                          );
                        case 2:
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('2-8 sep', style: AppTextStyles.chartstyle),
                          );
                           case 3:
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('9-15 sep', style: AppTextStyles.chartstyle),
                          );
                           case 4:
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('16-22 sep', style: AppTextStyles.chartstyle),
                          );
                           case 5:
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('25-29 sep', style: AppTextStyles.chartstyle),
                          );
                           case 6:
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.height(context, 10),
                              left: ResponsiveSize.width(context, 2),
                            ),
                            child: Text('30-33 sep', style: AppTextStyles.chartstyle),
                          );
                        
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
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth * 0.02,
                    top: constraints.maxHeight * 0.85,
                    child: Text(
                      "-₹80",
                      style: AppTextStyles.chartstyle.copyWith(
                        fontSize: ResponsiveSize.height(context, 12),
                        color:AppColors.redColor
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * 0.20,
                   top: constraints.maxHeight * 0,
                    
                    child: Text(
                      "₹477",
                      style: AppTextStyles.chartstyle.copyWith(
                        fontSize: ResponsiveSize.height(context, 12),
                      ),
                    ),
                  ),
                   Positioned(
                    left: constraints.maxWidth * 0.40,
                   top: constraints.maxHeight * 0.6,
                    
                    child: Text(
                      "₹80",
                      style: AppTextStyles.chartstyle.copyWith(
                        fontSize: ResponsiveSize.height(context, 12),
                      ),
                    ),
                  ),Positioned(
                    left: constraints.maxWidth * 0.55,
                    top: constraints.maxHeight * 0,
                    child: Text(
                      "₹0",
                      style: AppTextStyles.chartstyle.copyWith(fontSize: 12),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * 0.75,
                    top: constraints.maxHeight * 0.7,
                    child: Text(
                      "₹0",
                      style: AppTextStyles.chartstyle.copyWith(fontSize: 12),
                    ),
                  ), Positioned(
                    left: constraints.maxWidth * 0.90,
                    top: constraints.maxHeight * 0.7,
                    child: Text(
                      "₹0",
                      style: AppTextStyles.chartstyle.copyWith(fontSize: 12),
                    ),
                  ),
                  
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
