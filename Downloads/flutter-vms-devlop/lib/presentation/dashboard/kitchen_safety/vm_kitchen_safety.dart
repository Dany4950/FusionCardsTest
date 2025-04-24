import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/data/all_stores_data.dart';
import 'package:vms/manager/api_manager/requests/kitchen_requests.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/kitchen_safety_data.dart';
import '../../../manager/api_manager/api_controller.dart';
import '../stores/vm_stores.dart';

class VMKitchenSafety extends GetxController {
  final VMDateRange dateRangeVM = Get.find();
  RxInt activeIndex = RxInt(0);
  RxnInt currentPage = RxnInt();
  RxList<StoreData> storesData = RxList([]);
  RxBool isLoadingStores = RxBool(true);
  TabController? tabController;
  final PagingController<int, KsEmployeeData> pagingController =
      PagingController(firstPageKey: 0);

  RxList<KsEmployeeData> liveKitSafe = RxList();

  Future<void> fetchStores(TickerProvider data) async {
    VMStores vmStores = Get.find();

    try {
      final stores = await vmStores.getAllStoresForDropdown();
      storesData.value = stores?.storeData
              .where((store) => store.hasKitchen == true)
              .toList() ??
          [];
      isLoadingStores.value = false;
      if (storesData.isNotEmpty) {
        tabController = TabController(
          length: storesData.length,
          vsync: data,
        );
        tabController?.addListener(() {
          if (tabController?.index != null) {
            if (tabController!.index != activeIndex.value) {
              activeIndex.value = tabController!.index;
              currentPage.value = null;
              pagingController.refresh();
            }
          }
        });
      }
    } catch (e) {
      isLoadingStores.value = false;
    }
  }

  Future getKitchenSafetyDetailsOfAllEmployeesByStore(int storeId, int page,
      {DateRangeType range = DateRangeType.lastWeek}) async {
    try {
      dateRangeVM.handleEnable(false);
      final pageKey = page + 1;
      final res = await APIController.to.request(
        KitchenRequests.fetchSafety(storeId, pageKey, range),
      );

      if (res.isSuccess) {
        KitchenSafetyMain? data = res.data?.dataModel;
        List<KsEmployeeData> mainData = data?.data ?? [];
        bool isLastPage = mainData.length < 10;
        if (isLastPage) {
          pagingController.appendLastPage(mainData);
        } else {
          pagingController.appendPage(mainData, pageKey);
        }
      } else {
        pagingController.error = res.message;
      }
    } catch (e) {
      pagingController.error = e;
    } finally {
      dateRangeVM.handleEnable(true);
    }
  }

  Future<bool> getLiveKitchenSafetyDetailsOfAllEmployees(int storeId,
      {DateRangeType range = DateRangeType.lastWeek}) async {
    final res = await APIController.to.request(
      KitchenRequests.fetchLiveSafety(storeId, 1),
    );

    if (res.isSuccess) {
      liveKitSafe.value = res.data?.dataModel?.data ?? [];
      return true;
    } else {
      pagingController.error = res.message;
      return false;
    }
  }
}
