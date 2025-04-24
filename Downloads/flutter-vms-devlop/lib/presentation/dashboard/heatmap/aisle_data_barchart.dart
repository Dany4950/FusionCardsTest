import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';
import 'package:vms/utils/util_functions.dart';

class AisleDataBarChart extends StatefulWidget {
  final int storeId;
  final bool isLive;
  const AisleDataBarChart(
      {super.key, required this.storeId, required this.isLive});

  @override
  State<AisleDataBarChart> createState() => AisleDataBarChartState();
}

class AisleDataBarChartState extends State<AisleDataBarChart> {
  bool isLoading = false;
  String? error;
  VMHeatmap vmHeatmap = Get.put(VMHeatmap());

  double calculateMaxYValue() {
    final data =
        widget.isLive ? vmHeatmap.liveStoreAisleData : vmHeatmap.storeAisleData;
    final maxYValue = data
        .map((data) => int.tryParse(data['count'].toString()) ?? 0)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    return maxYValue;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Obx(() {
      final data = widget.isLive
          ? vmHeatmap.liveStoreAisleData
          : vmHeatmap.storeAisleData;

      if (data.isEmpty) {
        return const SizedBox.shrink();
      }

      final screenWidth = MediaQuery.of(context).size.width - 32;
      final minBarWidth = screenWidth / 5;
      final totalWidth = data.length * minBarWidth;
      final chartWidth = max(screenWidth, totalWidth);

      return Container(
        height: 350,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
              child: Text(
                widget.isLive
                    ? 'Live People Count by Aisle'
                    : 'People Count by Aisle',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: -60,
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                      ),
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: calculateMaxYValue(),
                      interval: calculateMaxYValue().yInterval,
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                      ),
                      isVisible: false,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<Map<String, dynamic>, String>(
                        animationDuration: 500,
                        dataSource: data,
                        xValueMapper: (Map<String, dynamic> data, _) =>
                            data['aisle'].toString().toUpperCase(),
                        yValueMapper: (Map<String, dynamic> data, _) =>
                            int.tryParse(data['count'].toString()) ?? 0,
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(4),
                        spacing: 0.1,
                        width: 0.6,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          alignment: ChartAlignment.center,
                          offset: const Offset(0, 5),
                          textStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          builder: (dynamic data, dynamic point, dynamic series,
                              int pointIndex, int seriesIndex) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                point.y.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                        enable: true,
                        builder: (dynamic data, dynamic point, dynamic series,
                            int pointIndex, int seriesIndex) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${data['aisle'].toString().toUpperCase()}: ${point.y}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }),
                    plotAreaBorderWidth: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
