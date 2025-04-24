import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vms/data/people_count_history_data.dart';
import 'package:vms/presentation/dashboard/people_count/busy_hour_projection_chart.dart';
import 'package:vms/presentation/dashboard/people_count/customer_forecast_table.dart';
import 'package:vms/presentation/dashboard/people_count/people_count_live.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/dashboard/stores/stores_screen.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/expansion_tile.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/widgets/stores_date_tab_bars.dart';

import '../../../common/colors.dart';

class PeopleCountScreen extends StatefulWidget {
  const PeopleCountScreen({super.key});

  @override
  State<PeopleCountScreen> createState() => _PeopleCountScreenState();
}

class _PeopleCountScreenState extends State<PeopleCountScreen> {
  final VMPeopleCount vmPeopleCount = Get.find();
  // final DateRangeVM dateRangeVM = Get.find();
  final VMDateRange dateRangeVM = Get.put(VMDateRange());
  VMStores vmStores = Get.find();

  // Add variables to store listener subscriptions
  late Worker _storesListener;
  late Worker _selectedStoreListener;
  late Worker _dateListener;
  late Worker
      _dateListener2; // For the second date listener at the end of initState

  @override
  void dispose() {
    // Cancel all the listeners
    _storesListener.dispose();
    _selectedStoreListener.dispose();
    _dateListener.dispose();
    _dateListener2.dispose();

    // Remove page request listener
    vmPeopleCount.pagingController
        .removePageRequestListener(_pageRequestListener);

    super.dispose();
  }

  void _pageRequestListener(int pageKey) {
    if (vmStores.storesForDropDown.value != null) {
      vmPeopleCount.currentPage.value = pageKey;
      vmPeopleCount.getPeopleCountHistory(
        vmStores.selectedStore.value!.id,
        pageKey,
        range: dateRangeVM.selectedDate.value,
      );
      vmPeopleCount.getPeopleCountHistory(
        vmStores.selectedStore.value!.id,
        pageKey,
        range: dateRangeVM.selectedDate.value,
        isDropdown: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    vmPeopleCount.isShowForecastEnabled.value = true;

    // Use ever() instead of listen() to get a Worker reference
    _storesListener = ever(vmStores.storesForDropDown, (stores) {
      if (stores != null) {
        vmPeopleCount.pagingController.refresh();
      }
    });

    _selectedStoreListener = ever(vmStores.selectedStore, (store) {
      if (store != null) {
        vmPeopleCount.pagingController.refresh();
      }
    });

    _dateListener = ever(dateRangeVM.selectedDate, (dateType) {
      vmPeopleCount.pagingController.refresh();
    });

    vmPeopleCount.pagingController.refresh();
    vmPeopleCount.pagingController.addPageRequestListener(_pageRequestListener);

    // This is a duplicate listener that was in the original code
    // Keeping it for consistency but using Worker for proper disposal
    _dateListener2 = ever(dateRangeVM.selectedDate, (dateType) {
      vmPeopleCount.pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMPeopleCount>(
        init: vmPeopleCount,
        builder: (_) {
          return Scaffold(
            appBar: MoksaNavBar(
              "Show Forecast",
              trailingWidget: Obx(() => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CupertinoSwitch(
                      value: vmPeopleCount.isShowForecastEnabled.value ?? false,
                      onChanged: (value) {
                        vmPeopleCount.isShowForecastEnabled.value = value;
                        if (vmPeopleCount.isShowForecastEnabled.value ==
                            false) {
                          dateRangeVM.selectedDate.value =
                              DateRangeType.lastWeek;
                          vmPeopleCount.getPeopleCountHistory(
                              vmStores.selectedStore.value!.id, 0);
                          dateRangeVM.handleEnable(true);
                        } else if (vmPeopleCount.isShowForecastEnabled.value ==
                            true) {
                          dateRangeVM.selectedDate.value =
                              DateRangeType.tommorrow;
                          vmPeopleCount.pagingController.refresh();
                          vmPeopleCount.getCustomerForecast(
                              vmStores.selectedStore.value!.id.toString());
                          dateRangeVM.handleEnable(true);
                        }
                      },
                    ),
                  )),
            ),
            backgroundColor: AppColors.white,
            body: Obx(
              () => vmStores.storesForDropDown.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        StoresDateTabBars(),
                        Gap(4),
                        Expanded(
                          child: Obx(() {
                            if (vmStores.isLiveSelected) {
                              return PeopleCountLiveWidget();
                            } else if (vmPeopleCount
                                    .isShowForecastEnabled.value ==
                                false) {
                              return Column(
                                children: [
                                  if (vmPeopleCount
                                          .storeSummeryCardData.value !=
                                      null)
                                    PeopleCountCard(
                                      vmPeopleCount.storeSummeryCardData.value!,
                                      isLoading: vmPeopleCount.isLoading.value,
                                    ),
                                  Expanded(
                                    child: PeopleCountTable(
                                      pagingController:
                                          vmPeopleCount.pagingController,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    BusyHourProjectionChart(
                                        storeId: vmStores
                                            .selectedStore.value!.id
                                            .toString(),
                                        type: dateRangeVM.selectedDate.value,
                                        key: ValueKey(
                                            'chart-${vmStores.selectedStore.value!.id}')),
                                    Gap(20),
                                    CustomerForecastTable(
                                        storeId: vmStores
                                            .selectedStore.value!.id
                                            .toString(),
                                        type: dateRangeVM.selectedDate.value,
                                        key: ValueKey(
                                            'table-${vmStores.selectedStore.value!.id}')),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
            ),
          );
        });
  }
}

class PeopleCountTable extends StatelessWidget {
  final PagingController<int, PeopleCountDataPerStore> pagingController;

  const PeopleCountTable({
    super.key,
    required this.pagingController,
  });

  @override
  Widget build(BuildContext context) {
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
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: const [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Customers',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Projection',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: PagedListView<int, PeopleCountDataPerStore>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<PeopleCountDataPerStore>(
              firstPageProgressIndicatorBuilder: (_) =>
                  const SizedBox.shrink(), // Remove default loader
              newPageProgressIndicatorBuilder: (_) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No data available'),
              ),
              itemBuilder: (context, item, index) {
                String dateText = item.month != 'N/A'
                    ? item.month
                    : item.date != 'N/A'
                        ? Jiffy.parse(item.date).format(pattern: 'MMM do')
                        : item.month;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Table(
                    border: TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Text(
                              '$dateText ${item.hour}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Text(
                              item.noofcustomers.toString(),
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
                                  '${item.predictedmean}',
                                  textAlign: TextAlign.center,
                                ),
                                Gap(5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: double.parse(item.predictedPercentage
                                                .toString()) >=
                                            0
                                        ? Colors.red.shade200
                                        : Colors.green.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "${int.parse(item.predictedPercentage.toString()).abs()}%",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
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
        ),
      ],
    );
  }
}

class PeopleCountCardSkeleton extends StatelessWidget {
  const PeopleCountCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class PeopleCountHistoryItem extends StatelessWidget {
  final PeopleCountDataPerStore item;

  const PeopleCountHistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  if (item.date != 'N/A')
                    Text(
                      Jiffy.parse(item.date).format(pattern: 'MMM do'),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  if (item.hour != '0')
                    Text(
                      item.hour,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  if (item.month != 'N/A')
                    Text(
                      item.month,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customers ${item.noofcustomers} "),
                    Text(
                        "Projections ${item.predictedmean} (${item.predictedPercentage}%)"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PeopleCountCard extends StatelessWidget {
  final PeopleCountDataPerStore store;
  final Color chartBarColor;
  final Color chartBusyHourColor;
  final bool isLoading;

  const PeopleCountCard(
    this.store, {
    super.key,
    this.isLoading = false,
    this.chartBarColor = const Color(0xFF4285F4),
    this.chartBusyHourColor = const Color(0xFFEA4335),
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const PeopleCountCardSkeleton();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: MoksaExpansionTile(
            title: store.store,
            subTitle: 'Total Count: ${store.noofcustomers}',
            leadingIcon: Container(
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              child: Image.asset(
                "assets/images/home.png",
              ),
            ),
            children: [
              // Pair("Busy Hour Projections:",
              //     store.busyhour.isEmpty ? "Nil" : store.busyhour),
              _buildTimeInfoRow(store),
              Pair(
                "Customer Projection:",
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.predictedmean.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: double.parse(
                                    store.predictedPercentage.toString()) >=
                                0
                            ? Colors.red.shade200
                            : Colors.green.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${int.parse(store.predictedPercentage.toString()).abs()}%",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Pair _buildTimeInfoRow(PeopleCountDataPerStore store) {
    if (store.busyhour != null &&
        store.busyhour.isNotEmpty &&
        store.busyhour != "N/A") {
      return Pair("Busy Hour:", store.busyhour);
    } else if (store.date != null &&
        store.date.isNotEmpty &&
        store.date != "N/A") {
      // Added check for "-" value
      return Pair("Busy Date:", store.date);
    } else if (store.month != null && store.month.isNotEmpty) {
      return Pair("Busy Month:", store.month);
    } else {
      // Fallback message
      return Pair("Time Info:", "Not available");
    }
  }
}

class SpacedPairRowWithPercentage extends StatelessWidget {
  final String label;
  final String value;
  final dynamic percentage;

  const SpacedPairRowWithPercentage({
    super.key,
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withAlpha(153),
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: double.parse(percentage.toString()) >= 0
                    ? Colors.red.shade300
                    : Colors.green.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${int.parse(percentage.toString()).abs()}%",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
