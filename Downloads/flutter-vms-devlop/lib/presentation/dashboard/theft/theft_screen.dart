import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/dashboard/theft/theft_list.dart';
import 'package:vms/presentation/dashboard/theft/theft_live.dart';
import 'package:vms/presentation/dashboard/theft/theft_trends_widget.dart';
import 'package:vms/presentation/dashboard/theft/thefts_chart.dart';
import 'package:vms/presentation/dashboard/theft/vm_theft.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/widgets/stores_date_tab_bars.dart';

import '../../../common/colors.dart';

class TheftScreen extends StatefulWidget {
  const TheftScreen({super.key});

  @override
  State<TheftScreen> createState() => _TheftScreenState();
}

class _TheftScreenState extends State<TheftScreen> {
  VMTheft vmTheft = Get.find();
  VMStores vmStores = Get.find();
  final VMDateRange dateRangeVM = Get.find();

  // Add variables to store listener subscriptions
  late final List<VoidCallback> _listeners = [];
  late Worker _storesListener;
  late Worker _selectedStoreListener;
  late Worker _dateListener;

  @override
  void dispose() {
    // Cancel all the listeners
    _storesListener.dispose();
    _selectedStoreListener.dispose();
    _dateListener.dispose();

    // Remove page request listener
    vmTheft.pagingController.removePageRequestListener(_pageRequestListener);

    super.dispose();
  }

  void _pageRequestListener(int pageKey) {
    if (vmStores.storesForDropDown.value != null) {
      vmTheft.currentPage.value = pageKey;
      vmTheft.getTheftListByStoreId(
        vmStores.selectedStore.value!.id.toString(),
        pageKey,
        range: dateRangeVM.selectedDate.value,
      );
    }
  }

  Future<void> refreshAllData() async {
    if (vmStores.selectedStore.value != null) {
      dateRangeVM.handleEnable(false);
      vmTheft.pagingController.refresh();

      // Collect API calls into a list of futures
      List<Future> futures = [
        vmTheft.getTheftDetectionDetailsByStoreId(
          vmStores.selectedStore.value!.id.toString(),
          vmTheft.currentPage.value ?? 0,
          range: dateRangeVM.selectedDate.value,
        ),
        vmTheft.theftTrendsOfAllTime(
          vmStores.selectedStore.value!.id.toString(),
          vmTheft.currentPage.value ?? 0,
          range: dateRangeVM.selectedDate.value,
        ),
        if (vmStores.selectedStore.value?.id != -1)
          vmTheft.getTheftListByStoreId(
            vmStores.selectedStore.value!.id.toString(),
            vmTheft.currentPage.value ?? 0,
            range: dateRangeVM.selectedDate.value,
          ),
      ];
      await Future.wait(futures);
      dateRangeVM.handleEnable(true);
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize listeners with proper references so they can be disposed later
    _storesListener = ever(vmStores.storesForDropDown, (stores) {
      if (stores != null) {
        refreshAllData();
      }
    });

    _selectedStoreListener = ever(vmStores.selectedStore, (store) {
      if (store != null) {
        refreshAllData();
      }
    });

    _dateListener = ever(dateRangeVM.selectedDate, (dateType) {
      refreshAllData();
    });

    vmTheft.pagingController.addPageRequestListener(_pageRequestListener);

    refreshAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoksaNavBar(
        "Theft",
      ),
      backgroundColor: AppColors.white,
      body: Obx(
        () => vmStores.storesForDropDown.value == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const Gap(4),
                  StoresDateTabBars(),
                  Expanded(
                    child: vmStores.isLiveSelected
                        ? TheftLiveWidget()
                        : TheftList(
                            topItems: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(8),
                                  TheftsDetectedChart(
                                    storeId: vmStores.selectedStore.value?.id
                                            .toString() ??
                                        '-1',
                                    key: ValueKey(
                                        '${vmStores.selectedStore.value?.id.toString()}_${dateRangeVM.selectedDate.value}'),
                                    range: dateRangeVM.selectedDate.value,
                                  ),
                                  Gap(15),
                                  TheftTrendsWidget(
                                    storeId: vmStores.selectedStore.value?.id
                                            .toString() ??
                                        '-1',
                                    isLive: false,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Recent Thefts',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
