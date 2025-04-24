import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/heatmap/aisle_data.dart';
import 'package:vms/presentation/dashboard/heatmap/aisle_data_barchart.dart';
import 'package:vms/presentation/dashboard/heatmap/aisle_data_pie_chart.dart';
import 'package:vms/presentation/dashboard/heatmap/heatmap.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/widgets/stores_date_tab_bars.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  _HeatmapScreenState createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen>
    with SingleTickerProviderStateMixin {
  VMHeatmap vmHeatmap = Get.find();
  VMStores vmStores = Get.find();
  final VMDateRange dateRangeVM = Get.find();

  // Worker references to manage listeners
  Worker? storesWorker;
  Worker? selectedStoreWorker;
  Worker? dateRangeWorker;

  void refreshAllData() {
    if (vmStores.selectedStore.value != null) {
      vmHeatmap.pagingController.refresh();

      vmHeatmap.getAisleDatabyStoreid(
        vmStores.selectedStore.value!.id,
        vmHeatmap.currentPage.value ?? 0,
        range: dateRangeVM.selectedDate.value,
      );

      vmHeatmap.getFloormapByStoreId(
        vmStores.selectedStore.value!.id,
        vmHeatmap.currentPage.value ?? 0,
        range: dateRangeVM.selectedDate.value,
      );

      // vmHeatmap.getHeatImagesDataByStoreId(
      //   vmStores.selectedStore.value!.id,
      //   vmHeatmap.currentPage.value ?? 0,
      //   range: dateRangeVM.selectedDate.value,
      // );
    }
  }

  void _setupListeners() {
    // Cleanup existing workers if any
    _disposeListeners();

    storesWorker = ever(vmStores.storesForDropDown, (stores) {
      if (stores != null) {
        refreshAllData();
      }
    });

    selectedStoreWorker = ever(vmStores.selectedStore, (store) {
      if (store != null) {
        refreshAllData();
      }
    });

    dateRangeWorker = ever(dateRangeVM.selectedDate, (dateType) {
      refreshAllData();
    });

    vmHeatmap.pagingController.addPageRequestListener((pageKey) {
      if (vmStores.storesForDropDown.value != null) {
        vmHeatmap.currentPage.value = pageKey;
        vmHeatmap.getAisleDatabyStoreid(
          vmStores.selectedStore.value!.id,
          pageKey,
          range: dateRangeVM.selectedDate.value,
        );
      }
    });
  }

  void _disposeListeners() {
    storesWorker?.dispose();
    selectedStoreWorker?.dispose();
    dateRangeWorker?.dispose();
    vmHeatmap.pagingController.removePageRequestListener((pageKey) {});
  }

  @override
  void initState() {
    super.initState();
    _setupListeners();
    refreshAllData();
  }

  @override
  void dispose() {
    _disposeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoksaNavBar(
        "Heatmap",
      ),
      backgroundColor: AppColors.white,
      body: Obx(
        () => vmStores.storesForDropDown.value == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  StoresDateTabBars(
                    isHeatmapScreen: true,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AisleDataGrid(
                              storeId: vmStores.selectedStore.value!.id,
                              isLive: false,
                            ),
                            Gap(8),
                            AisleDataBarChart(
                              storeId: vmStores.selectedStore.value!.id,
                              isLive: false,
                            ),
                            Gap(8),
                            AisledataPieChart(
                              storeId: vmStores.selectedStore.value!.id,
                              isLive: false,
                            ),
                            Gap(8),
                            Obx(() {
                              return Heatmap(
                                storeId: vmStores.selectedStore.value!.id,
                                key: ValueKey(vmStores.selectedStore.value!.id),
                              );
                            }),
                            // Heatmap()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
