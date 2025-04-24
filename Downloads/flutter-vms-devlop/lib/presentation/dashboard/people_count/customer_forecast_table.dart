import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vms/data/people_count_history_data.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

class CustomerForecastTable extends StatefulWidget {
  final String storeId;
  final DateRangeType type;

  const CustomerForecastTable({
    super.key,
    required this.storeId,
    required this.type,
  });

  @override
  State<CustomerForecastTable> createState() => _CustomerForecastTableState();
}

class _CustomerForecastTableState extends State<CustomerForecastTable> {
  VMPeopleCount vmPeopleCount = Get.find();
  RxBool isLoading = RxBool(true);
  RxnString error = RxnString();
  // Add a local variable to store forecast data
  final RxList<ForecastData> forecastData = RxList<ForecastData>([]);

  @override
  void initState() {
    super.initState();
    fetchData();
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
        error.value = 'No forecast Data available for this store.';
      } else {
        forecastData.assignAll(data);
      }
    } catch (e) {
      error.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void didUpdateWidget(covariant CustomerForecastTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.storeId != oldWidget.storeId || widget.type != oldWidget.type) {
      fetchData();
    }
  }

  String getColumenHeaderText() {
    if (widget.type == DateRangeType.today ||
        widget.type == DateRangeType.tommorrow) {
      return 'Time';
    } else if (widget.type == DateRangeType.nextWeek ||
        widget.type == DateRangeType.nextMonth) {
      return 'Date';
    } else {
      return 'Busy Period';
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error.value ?? "",
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      }

      if (forecastData.isEmpty) {
        return const Center(
          child: Text(
            'No projection data available',
            style: TextStyle(color: Colors.black87),
          ),
        );
      }

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Table(
              border: TableBorder(
                horizontalInside:
                    BorderSide(color: Colors.grey.shade300, width: 1),
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              columnWidths: const {
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        getColumenHeaderText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Projections',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                final item = forecastData[index];
                final dateText = item.date != null
                    ? Jiffy.parse(item.date!).format(pattern: 'MMM do')
                    : item.time;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Table(
                    border: TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    columnWidths: const {
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Text(
                              dateText!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${item.predictedMean}',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
