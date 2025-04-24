import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/data/people_count/people_count_live_response.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/people_count_history_data.dart';
import '../../../manager/api_manager/api_controller.dart';
import '../../../manager/api_manager/requests/people_count_request.dart';

class VMPeopleCount extends GetxController {
  RxnInt currentPage = RxnInt(0);
  final PagingController<int, PeopleCountDataPerStore> pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 5);
  final RxList<StorePeopleCountItem> liveStoreDataList =
      RxList<StorePeopleCountItem>();
  final RxList<BusyHourProjection> busyHourProjections =
      RxList<BusyHourProjection>();
  final RxBool isForecastScreen = RxBool(true);

  final storeSummeryCardData = Rxn<PeopleCountDataPerStore>();

  final VMDateRange dateRangeVM = Get.find(); // added DateRangeVM dependency

  RxnBool isShowForecastEnabled = RxnBool(false);
  final RxBool isLoading = RxBool(false);

  @override
  void onClose() {
    isShowForecastEnabled.value = false;
    super.onClose();
  }

// isDropdown is used to check if the data is coming from the dropdown or not
  Future getPeopleCountHistory(
    int storeId,
    int page, {
    DateRangeType range = DateRangeType.lastWeek,
    bool isDropdown = false,
  }) async {
    try {
      isLoading.value = true;
      if (page == 0) {
        pagingController.itemList?.clear();
        storeSummeryCardData.value = null;
      }
      dateRangeVM.handleEnable(false);
      final pageKey = page + 1;
      final res = await APIController.to.request(
        await PeopleCountRequest.getPeopleCount(
          storeId.toString(),
          pageKey.toString(),
          range,
          isDropDown: isDropdown,
        ),
      );

      if (res.isSuccess) {
        // for table
        PeopleCountHistoryItem? data = res.data?.dataModel;
        // for Summery card
        List<PeopleCountDataPerStore> peopleCountDataList =
            data?.peopleCountDataPerStore ?? [];

        if (isDropdown && peopleCountDataList.isEmpty) {
          return;
        }

        if (!isDropdown && peopleCountDataList.isNotEmpty) {
          storeSummeryCardData.value = peopleCountDataList.first;
          return;
        }

        final isLastPage = peopleCountDataList.length < 20;
        if (isLastPage) {
          pagingController.appendLastPage(peopleCountDataList);
        } else {
          pagingController.appendPage(peopleCountDataList, pageKey);
        }
      } else {
        pagingController.error = res.message;
      }
    } catch (e) {
      debugPrint("Exception in getPeopleCountHistory: $e");
    } finally {
      isLoading.value = false;
      dateRangeVM.handleEnable(true);
    }
  }

  Future<bool> getPeopleCountLive({
    int storeId = -1,
    int page = 1,
    bool isDropdown = false,
  }) async {
    final pageKey = page;
    dateRangeVM.handleEnable(false);
    try {
      final res = await APIController.to.request(
        PeopleCountRequest.getPeopleCountLive(
          storeId.toString(),
          pageKey.toString(),
          isDropDown: isDropdown,
        ),
      );

      if (res.isSuccess) {
        liveStoreDataList
            .assignAll(res.data?.dataModel?.storePeopleCountItems ?? []);
        return true;
      } else {
        debugPrint("Error fetching live data: ${res.message}");
      }
    } catch (e) {
      debugPrint("Error fetching live data: $e");
    } finally {
      dateRangeVM.handleEnable(true);
    }

    return false;
  }

  Future<List<ForecastData>> getCustomerForecast(String storeId,
      {DateRangeType type = DateRangeType.tommorrow}) async {
    try {
      dateRangeVM.handleEnable(false);
      List<ForecastData> forecastDataList = [];

      final res = await APIController.to.request(
        PeopleCountRequest.getCustomerForecast(storeId, type),
      );

      if (!res.isSuccess || res.data == null) return [];

      if (type == DateRangeType.tommorrow || type == DateRangeType.today) {
        final response = res.data as List<BusyHourProjection>;
        forecastDataList = response
            .map((e) => ForecastData.fromBusyHourProjection(e))
            .toList();

        return forecastDataList;
      }

      if (type == DateRangeType.nextWeek || type == DateRangeType.nextMonth) {
        final response = res.data as WeeklyForecastResponse;
        forecastDataList = response.data
            .map((e) => ForecastData.fromWeeklyForecast(e))
            .toList();
      }

      return forecastDataList;
    } catch (e) {
      return [];
    } finally {
      dateRangeVM.handleEnable(true);
    }
  }
}
