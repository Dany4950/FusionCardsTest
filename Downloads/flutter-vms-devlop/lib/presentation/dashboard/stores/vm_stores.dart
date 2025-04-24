import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/manager/api_manager/requests/store_requests.dart';

import '../../../data/all_store_details_data_by_id.dart';
import '../../../data/all_stores_data.dart';
import '../../../data/store_totals.dart';
import '../../../data/store_totals_data.dart';
import '../../../manager/api_manager/api_controller.dart';

class VMStores extends GetxController {
  final PagingController<int, AllStoreDetailsItem> pagingController =
      PagingController(firstPageKey: 0);

  Future getStoreByStoreIdWithAllDetails(
      {int storeId = -1, int page = 1}) async {
    final pageKey = page + 1;
    final res = await APIController.to.request(
      await StoreRequest.fetchStores(storeId, pageKey),
    );

    if (res.isSuccess) {
      List<AllStoreDetailsItem> data = res.data?.dataModels ?? [];
      final isLastPage = data.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(data);
      } else {
        pagingController.appendPage(data, pageKey);
      }
    } else {
      pagingController.error = res.message;
    }
  }

  Future<StoreTotals?> getAllStoresTotals(int storeId) async {
    final res = await APIController.to.request(
      StoreRequest.getAllStoresTotals(storeId),
    );

    if (res.isSuccess) {
      StoreTotalsItem? data = res.data?.dataModel;

      return StoreTotals(
        totalStores: data?.totalstorecount ?? "",
        totalCameras: data?.totalcameracount ?? "",
        theftsDetected: data?.totaldetectedthefts ?? "",
        theftsPrevented: data?.totalpreventedthefts ?? "",
      );
    } else {
      debugPrint('Error: ${res.message}');
      return null;
    }
  }

  VMStores() {
    getAllStoresForDropdown();
  }

  List<StoreData> getStores(
    bool isKitchenScreen,
    bool shouldShowLive,
  ) {
    List<StoreData>? storeData = storesForDropDown.value
        ?.where((store) =>
            isKitchenScreen ? store.hasKitchen == true || store.id == -1 : true)
        .where((store) => shouldShowLive ? true : store.id != -1)
        .toList();

    return storeData ?? [];
  }

  final Rxn<List<StoreData>> storesForDropDown = Rxn();
  final Rxn<StoreData> selectedStore = Rxn();
  final RxBool isLoadingStores = false.obs;

  get isLiveSelected => selectedStore.value?.id == -1;

  get isStoreWithKitechSelected => selectedStore.value?.hasKitchen;

  Future<StoresDDItem?> getAllStoresForDropdown() async {
    if (storesForDropDown.value != null) {
      return StoresDDItem(storeData: storesForDropDown.value!);
    }

    final res = await APIController.to.request(
      StoreRequest.getAllStoresForDropdown(),
    );

    if (res.isSuccess) {
      StoresDDItem? data = res.data?.dataModel;
      // Sort the store data alphabetically
      final storesList = data?.storeData;
      if (storesList != null) {
        storesList.sort((a, b) {
          if (a.id == -1) return -1;
          if (b.id == -1) return 1;
          return a.name.compareTo(b.name);
        });
      }

      storesForDropDown.value = storesList;
      selectedStore.value = data?.storeData.first;
      isLoadingStores.value = false;
      return data;
    } else {
      return null;
    }
  }
}
