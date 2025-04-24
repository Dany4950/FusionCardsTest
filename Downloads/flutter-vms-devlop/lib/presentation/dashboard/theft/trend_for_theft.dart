import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/utils/util_functions.dart';
import 'package:vms/utils/widgets/common_widget.dart';

import '../../../data/theft/m_theft_trends.dart';

class CustomLineChart extends StatelessWidget {
  final List<MTheftTrends> data;

  CustomLineChart(this.data, {super.key});

  final List<Color> gradientColors = [
    AppColors.yellow,
    AppColors.green,
  ];

  // Define ordered days of week
  final List<String> orderedDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Get ordered data with zero values for missing days
  List<MTheftTrends> getOrderedData() {
    Map<String, MTheftTrends> dataMap = {};
    for (var item in data) {
      dataMap[item.dayOfWeek?.toLowerCase() ?? ""] = item;
    }

    return orderedDays.map((day) {
      return dataMap[day.toLowerCase()] ??
          MTheftTrends(dayOfWeek: day, theftCount: "0");
    }).toList();
  }

  double calculateMaxX() {
    return 6; // Fixed for 7 days (0-6)
  }

  double calculateMaxY() {
    if (data.isEmpty) return 1; // Return 1 if no data

    List<double> numbers =
        data.map((item) => double.parse(item.theftCount ?? "0")).toList();

    double maxNumber =
        numbers.reduce((current, next) => current > next ? current : next);

    return maxNumber > 5 ? maxNumber : 5;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final orderedData = getOrderedData();
    String text = orderedData[value.toInt()].dayOfWeek?.substring(0, 1) ?? "";

    return SideTitleWidget(
      meta: meta,
      child: text.isEmpty ? Container() : getText(text, fontSize: 10),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: getText(
        meta.formattedValue,
        fontSize: 10,
        textAlign: TextAlign.left,
      ),
    );
  }

  LineChartData mainData() {
    final orderedData = getOrderedData();

    return LineChartData(
      lineTouchData: const LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.moksaBlue,
            strokeWidth: 0.05,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
            interval: calculateMaxY().yInterval,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: calculateMaxX(),
      minY: 0,
      maxY: calculateMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              orderedData.length,
              (index) => FlSpot(
                    index.toDouble(),
                    double.parse(orderedData[index].theftCount ?? "0"),
                  )),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors.reversed
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
