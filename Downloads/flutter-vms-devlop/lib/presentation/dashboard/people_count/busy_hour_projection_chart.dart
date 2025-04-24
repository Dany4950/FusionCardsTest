import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vms/data/people_count_history_data.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/utils/util_functions.dart';

class BusyHourProjectionChart extends StatefulWidget {
  final String storeId;
  final Color barColor;
  final Color busyHourColor;
  final DateRangeType type;

  const BusyHourProjectionChart({
    super.key,
    required this.storeId,
    this.barColor = Colors.blue,
    this.busyHourColor = Colors.red,
    this.type = DateRangeType.today,
  });

  @override
  State<BusyHourProjectionChart> createState() =>
      _BusyHourProjectionChartState();
}

class _BusyHourProjectionChartState extends State<BusyHourProjectionChart> {
  VMPeopleCount vmPeopleCount = Get.find();
  RxBool isLoading = RxBool(true);
  RxnString error = RxnString();
  // Add local forecast data
  final RxList<ForecastData> forecastData = RxList<ForecastData>([]);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant BusyHourProjectionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.storeId != oldWidget.storeId || widget.type != oldWidget.type) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await vmPeopleCount.getCustomerForecast(
        widget.storeId,
        type: widget.type,
      );

      if (data.isEmpty) {
        error.value = 'No forecast data available for this store.';
      } else {
        forecastData.assignAll(data);
      }

      isLoading.value = false;
    } catch (e) {
      error.value = 'An error occurred: ${e.toString()}';
      isLoading.value = false;
    }
  }

  double calculateMaxYValue() {
    if (forecastData.isEmpty) return 0;

    final maxValue = forecastData
        .map((data) => data.predictedMean)
        .reduce((a, b) => a > b ? a : b);

    return maxValue == 0 ? 5 : (maxValue + 5);
  }

  String getBusyPeriodText() {
    if (widget.type == DateRangeType.today ||
        widget.type == DateRangeType.tommorrow) {
      return 'Busy Hours';
    } else if (widget.type == DateRangeType.nextWeek ||
        widget.type == DateRangeType.nextMonth) {
      return 'Busy Days';
    } else {
      return 'Busy Period';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const SizedBox(
          height: 150,
          width: 280,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (error.value != null) {
        return SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.value ?? "",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      if (forecastData.isEmpty) {
        return const SizedBox(
          height: 150,
          child: Center(
            child: Text(
              'No projection data available',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        );
      }

      final projections = forecastData;

      return SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Forecast',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: SfCartesianChart(
                          margin: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                          primaryXAxis: CategoryAxis(
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 9,
                            ),
                            labelRotation: -45,
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine: const AxisLine(width: 0),
                            majorTickLines: const MajorTickLines(size: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: calculateMaxYValue(),
                            interval: calculateMaxYValue().yInterval,
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 9,
                            ),
                            majorTickLines: const MajorTickLines(size: 5),
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<ForecastData, String>(
                              dataSource: projections,
                              xValueMapper: (ForecastData data, int index) =>
                                  data.xAxisLabel,
                              yValueMapper: (ForecastData data, _) =>
                                  data.predictedMean,
                              name: 'Predicted Traffic',
                              pointColorMapper: (ForecastData data, _) =>
                                  data.isBusy
                                      ? widget.busyHourColor
                                      : widget.barColor,
                              borderRadius: BorderRadius.circular(2),
                              spacing: 0.0,
                              width: 0.2,
                              animationDuration: 200,
                            ),
                          ],
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'point.x\nCustomers: point.y',
                          ),
                          plotAreaBorderWidth: 0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLegendItem('Regular', widget.barColor),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                            getBusyPeriodText(), widget.busyHourColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
