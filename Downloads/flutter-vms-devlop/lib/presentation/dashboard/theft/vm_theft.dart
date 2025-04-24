import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/theft/m_theft_trends.dart';
import '../../../data/theft/thefts_list_data.dart';
import '../../../data/theft_details.dart';
import '../../../manager/api_manager/api_controller.dart';
import '../../../manager/api_manager/requests/theft_request.dart';

class VMTheft extends GetxController {
  RxnInt currentPage = RxnInt(0);
  RxBool isFirstPageEmpty = RxBool(false);
  final PagingController<int, TheftsListItem> pagingController =
      PagingController(firstPageKey: 0);

  final RxList<TheftsListItem> liveTheftDataList =
      RxList<TheftsListItem>();

  Future<List<TheftsItem>?> getTheftDetectionDetailsByStoreId(
    String storeId,
    int page, {
    DateRangeType range = DateRangeType.lastWeek,
  }) async {
    final res = await APIController.to.request(
      TheftRequest.theftDetectionDetails(storeId, page, range),
    );

    if (res.isSuccess) {
      List<TheftsItem>? data = res.data?.dataModels;

      return data;
    } else {
      debugPrint('Error: ${res.message}');
      return null;
    }
  }

  Future<List<MTheftTrends>?> theftTrendsOfAllTime(
      String storeId, int page,
      {DateRangeType range = DateRangeType.lastWeek}) async {
    final res = await APIController.to.request(
      TheftRequest.theftTrendsOfAllTime(storeId, page, range),
    );

    if (res.isSuccess) {
      List<MTheftTrends>? data = res.data?.dataModels;
      return data;
    } else {
      debugPrint('Error: ${res.message}');
      return null;
    }
  }

  Future<void> getTheftListByStoreId(
    String storeId,
    int page, {
    DateRangeType range = DateRangeType.lastWeek,
  }) async {
    try {
      final res = await APIController.to.request(
        TheftRequest.getTheftListByStoreId(
            storeId.toString(), page, range),
      );

      if (res.isSuccess) {
        TheftsListItemData? data = res.data?.dataModel;
        List<TheftsListItem> list = data?.data ?? [];

        final totalCount = int.tryParse(data?.total ?? "0") ?? 0;

        if (page == 0) {
          isFirstPageEmpty.value = list.isEmpty;
        }

        final uniqueList = list.where((newItem) {
          final existingItems = pagingController.itemList ?? [];
          return !existingItems.any((existingItem) =>
              existingItem.videoUri == newItem.videoUri &&
              existingItem.dateValidated == newItem.dateValidated);
        }).toList();

        final isLastPage =
            (page + 1) * 10 >= totalCount || list.isEmpty;

        if (isLastPage) {
          debugPrint(
              'Reached last page with ${uniqueList.length} items');
          pagingController.appendLastPage(uniqueList);
        } else {
          debugPrint(
              'Appending page $page with ${uniqueList.length} items');
          pagingController.appendPage(uniqueList, page + 1);
        }
      } else {
        if (page == 0) {
          isFirstPageEmpty.value = true;
        }
        pagingController.error = res.message;
        debugPrint('Error loading page $page: ${res.message}');
      }
    } catch (e) {
      if (page == 0) {
        isFirstPageEmpty.value = true;
      }
      pagingController.error = e.toString();
      debugPrint('Exception loading page $page: $e');
    }
  }

  Future<bool> getLiveTheftListByStoreId(
      {int storeId = -1,
      DateRangeType range = DateRangeType.lastWeek}) async {
    liveTheftDataList.clear();
    final res = await APIController.to.request(
      TheftRequest.getTheftListByStoreId(
          storeId.toString(), 0, range),
    );

    if (res.isSuccess) {
      List<TheftsListItem> newList = res.data?.dataModel?.data ?? [];

      final uniqueItems = newList.where((item) {
        return liveTheftDataList.every((existingItem) =>
            item.videoUri != existingItem.videoUri ||
            item.dateValidated != existingItem.dateValidated);
      }).toList();

      liveTheftDataList.assignAll(uniqueItems);
      return true;
    } else {
      pagingController.error = res.message;
      return false;
    }
  }
}
