import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';

enum DateRangeType {
  oneHour('1 Hour', '1hr', 0),
  threeHours('3 Hours', '3hr', 0),
  fiveHours('5 Hours', '5hr', 0),
  sevenHours('7 Hours', '7hr', 0),
  oneDay('1 Day', '1day', 1),
  threeDays('3 Days', '3day', 3),
  sevenDays('7 Days', '7days', 7),
  live('Live', 'live', 0),
  yesterday('Yesterday', 'yesterday', 1),
  lastWeek('Last Week', '7', 7),
  lastMonth('Last Month', '30', 30),
  lastYear('Last Year', 'year', 365),
  today('Today', 'today', 0),
  tommorrow('Tommorrow', 'nextday', 0),
  nextWeek('NextWeek', 'nextsevendays', 0),
  nextMonth("Next Month", 'nextthirtydays', 0);

  static List<DateRangeType> getValues(bool shouldShowLive,
      {bool isHeatmap = false, bool isForecastEnabled = false}) {
    if (isHeatmap) {
      return [
        oneHour,
        threeHours,
        fiveHours,
        sevenHours,
        oneDay,
        threeDays,
        sevenDays,
      ];
    }

    if (isForecastEnabled) {
      return [today, tommorrow, nextWeek, nextMonth];
    }

    final regularRanges = [
      yesterday,
      lastWeek,
      lastMonth,
      lastYear,
    ];

    return shouldShowLive ? [live, ...regularRanges] : regularRanges;
  }

  final String label;
  final String value;
  final int daysAgo;

  const DateRangeType(this.label, this.value, this.daysAgo);
}

class VMDateRange extends GetxController {
  final selectedDate = DateRangeType.lastWeek.obs;
  final RxBool isEnable = true.obs;

  void handleEnable(bool value) {
    if (isEnable.value == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isEnable.value = value;
    });
  }
}

class DateRangeSelector extends StatefulWidget {
  final bool shouldShowLive;
  final bool isHeatmap;

  const DateRangeSelector({
    super.key,
    this.shouldShowLive = false,
    this.isHeatmap = false,
  });

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  final VMDateRange dateRangeVM = Get.find();
  final VMPeopleCount vmPeopleCount = Get.find();

  @override
  void initState() {
    super.initState();
    _updateDefaultValue();
  }

  @override
  void didUpdateWidget(DateRangeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isHeatmap != widget.isHeatmap ||
        widget.shouldShowLive != oldWidget.shouldShowLive) {
      _updateDefaultValue();
    }
  }

  void _updateDefaultValue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isHeatmap) {
        dateRangeVM.selectedDate.value = DateRangeType.sevenDays;
      } else if (vmPeopleCount.isShowForecastEnabled.value == true) {
        dateRangeVM.selectedDate.value = DateRangeType.tommorrow;
      } else {
        dateRangeVM.selectedDate.value = DateRangeType.lastWeek;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Gap(16),
            ...DateRangeType.getValues(widget.shouldShowLive,
                    isHeatmap: widget.isHeatmap,
                    isForecastEnabled:
                        vmPeopleCount.isShowForecastEnabled.value ?? false)
                .map((dateFilter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (dateRangeVM.isEnable.value) {
                      dateRangeVM.selectedDate.value = dateFilter;
                    }
                  },
                  child: Obx(() => Opacity(
                        opacity: dateRangeVM.isEnable.value ? 1 : 0.5,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            color: dateRangeVM.selectedDate.value == dateFilter
                                ? AppColors.moksaBlue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            dateFilter.label,
                            style: TextStyle(
                              color:
                                  dateRangeVM.selectedDate.value == dateFilter
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      )),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
