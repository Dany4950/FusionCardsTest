import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:vms/data/theft_details.dart';
import 'package:vms/presentation/dashboard/theft/vm_theft.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/utils/util_functions.dart';

class TheftsDetectedChart extends StatefulWidget {
  final String storeId;
  final Color detectedColor;
  final Color preventedColor;
  final DateRangeType range;

  const TheftsDetectedChart({
    super.key,
    required this.storeId,
    this.detectedColor = Colors.blue,
    this.preventedColor = Colors.red,
    required this.range,
  });

  @override
  State<TheftsDetectedChart> createState() => _TheftsDetectedChartState();
}

class _TheftsDetectedChartState extends State<TheftsDetectedChart> {
  VMTheft vmTheft = Get.find();
  RxList<TheftsItem> theftDetails = RxList([]);
  RxBool isLoading = RxBool(true);
  RxnString error = RxnString();

  bool get isMonthlyData =>
      theftDetails.isNotEmpty && theftDetails.first.monthName != null;
  bool get isWeeklyData =>
      theftDetails.isNotEmpty && theftDetails.first.dayOfWeek != null;
  bool get isDailyData =>
      theftDetails.isNotEmpty && theftDetails.first.date != null;

  final Map<String, int> dayOrder = {
    'Sunday': 0,
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await vmTheft.getTheftDetectionDetailsByStoreId(
        widget.storeId,
        1,
        range: widget.range,
      );

      if (data != null) {
        if (isWeeklyData) {
          data.sort((a, b) {
            final dayA = a.dayOfWeek?.trim() ?? '';
            final dayB = b.dayOfWeek?.trim() ?? '';
            return (dayOrder[dayA] ?? 0).compareTo(dayOrder[dayB] ?? 0);
          });
        }
        theftDetails.value = data;
        isLoading.value = false;
      } else {
        error.value = 'Failed to load data';
        isLoading.value = false;
      }
    } catch (e) {
      error.value = 'An error occurred: ${e.toString()}';
      isLoading.value = false;
    }
  }

  double calculateMaxYValue() {
    if (theftDetails.isEmpty) return 0;

    final maxDetected = theftDetails
        .map((data) => data.theftDetected)
        .reduce((a, b) => a > b ? a : b).toDouble();

    return maxDetected == 0 ? 5 : maxDetected;
  }

  String getFormattedXValue(TheftsItem data) {
    if (isMonthlyData) {
      return data.monthName?.trim() ?? '';
    } else if (isWeeklyData) {
      return data.dayOfWeek?.trim().substring(0, 3) ?? '';
    } else {
      final date = DateTime.tryParse(data.date ?? '');
      if (date != null) {
        return DateFormat('MMM dd').format(date);
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error.value != null) {
        return Center(
          child: Text(
            error.value ?? "",
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        );
      }

      if (theftDetails.isEmpty) {
        return const Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.black87),
          ),
        );
      }

      final screenWidth = MediaQuery.of(context).size.width - 32;
      final minBarWidth = isMonthlyData
          ? screenWidth / 5
          : isWeeklyData
              ? screenWidth / 7
              : screenWidth / 8;
      final totalWidth = theftDetails.length * minBarWidth;
      final chartWidth = max(screenWidth, totalWidth);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thefts Detected',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
            height: 350,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildLegendItem('Detected', widget.detectedColor),
                          const Gap(16),
                          _buildLegendItem('Prevented', widget.preventedColor),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: chartWidth,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                          ),
                          labelRotation: isMonthlyData ? 0 : 0,
                          majorGridLines: const MajorGridLines(width: 0),
                          axisLine: const AxisLine(width: 0),
                          maximumLabels: isMonthlyData
                              ? 12
                              : isWeeklyData
                                  ? 7
                                  : 31,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: calculateMaxYValue(),
                          interval: calculateMaxYValue().yInterval,
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                          ),
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<TheftsItem, String>(
                            dataSource: theftDetails,
                            xValueMapper: (TheftsItem data, _) =>
                                getFormattedXValue(data),
                            yValueMapper: (TheftsItem data, _) =>
                                data.theftDetected.toDouble(),
                            name: 'Detected',
                            color: widget.detectedColor,
                            borderRadius: BorderRadius.circular(4),
                            spacing: 0.1,
                            width: 0.65,
                          ),
                          ColumnSeries<TheftsItem, String>(
                            dataSource: theftDetails,
                            xValueMapper: (TheftsItem data, _) =>
                                getFormattedXValue(data),
                            yValueMapper: (TheftsItem data, _) =>
                                data.theftPrevented.toDouble(),
                            name: 'Prevented',
                            color: widget.preventedColor,
                            borderRadius: BorderRadius.circular(4),
                            spacing: 0.1,
                            width: 0.65,
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x\nDetected: point.y',
                        ),
                        plotAreaBorderWidth: 0,
                        margin: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
