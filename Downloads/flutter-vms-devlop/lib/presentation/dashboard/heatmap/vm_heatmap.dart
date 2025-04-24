import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/data/all_stores_data.dart';
import 'package:vms/manager/api_manager/api_controller.dart';
import 'package:vms/manager/api_manager/requests/heatmap_request.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

class VMHeatmap extends GetxController {
  RxInt activeIndex = RxInt(0);
  RxnInt currentPage = RxnInt();
  Rxn<StoresDDItem> storesData = Rxn();
  RxBool isLoadingStores = RxBool(true);
  TabController? tabController;
  final PagingController<int, AisleCountData> pagingController =
      PagingController(firstPageKey: 0);
  final VMDateRange dateRangeVM = Get.find();

  RxList<Map<String, dynamic>> storeAisleData = RxList([]);
  RxList<Map<String, dynamic>> liveStoreAisleData = RxList([]);
  RxString floormapBase64 = ''.obs;
  RxBool isLoadingHeatmap = false.obs;
  RxBool isProcessingData = false.obs;
  RxBool isLiveMode = false.obs;
  final Rx<Uint8List?> floormapImageData = Rx<Uint8List?>(null);
  RxList<HeatmapData> floormapImagesDataList = <HeatmapData>[].obs;

  Future<void> fetchStores(TickerProvider data) async {
    VMStores vmStores = Get.find();

    try {
      final stores = await vmStores.getAllStoresForDropdown();
      storesData.value = stores;
      isLoadingStores.value = false;
      if (storesData.value != null && storesData.value!.storeData.isNotEmpty) {
        tabController = TabController(
          length: storesData.value!.storeData.length,
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

  Future<void> getAisleDatabyStoreid(int storeId, int page,
      {DateRangeType range = DateRangeType.sevenDays}) async {
    try {
      dateRangeVM.handleEnable(false);
      final res = await APIController.to.request(
        await HeatmapRequest.fetchAisleData(storeId.toString(), page, range),
      );

      if (res.isSuccess && res.data?.data != null) {
        final List<StoreAisleData> storeDataList = res.data?.data ?? [];

        if (storeDataList.isNotEmpty) {
          storeAisleData.value = storeDataList.expand((storeData) {
            return storeData.aisleDetails.entries.map((entry) {
              return {
                'aisle': entry.key,
                'count': entry.value.count.toString(),
                'timespent': entry.value.timespent,
                'percentage': '${entry.value.percentage.toStringAsFixed(2)}%',
              };
            }).toList();
          }).toList();
        } else {
          storeAisleData.clear();
        }
      } else {
        storeAisleData.clear();
      }
    } catch (e, stack) {
      debugPrint('Error fetching aisle data: $e\n$stack');
      storeAisleData.clear();
    } finally {
      dateRangeVM.handleEnable(true);
    }
  }

  Future<void> getLiveAisleDataByStoreId(int storeId) async {
    try {
      dateRangeVM.handleEnable(false);
      final res = await APIController.to.request(
        await HeatmapRequest.fetchLiveHeatmapData(storeId.toString()),
      );

      debugPrint('Live API Response: ${res.response?.data}');

      if (res.isSuccess && res.response?.data != null) {
        final data = res.response?.data['data'];

        if (data != null && data is List && data.isNotEmpty) {
          final storeData = data[0];
          _processAisleDetails(storeData['aisle_details']);
        }
      } else {
        liveStoreAisleData.clear();
      }
    } catch (e, stack) {
      debugPrint('Error in getLiveHeatmapDataByStoreId: $e\n$stack');
      liveStoreAisleData.clear();
    } finally {
      dateRangeVM.handleEnable(true);
    }
  }

  void _processAisleDetails(dynamic aisleDetails) {
    if (aisleDetails == null) return;
    try {
      isProcessingData.value = true;
      final Map<String, Map<String, dynamic>> newData = {};

      aisleDetails.forEach((aisle, details) {
        newData[aisle.toString()] = {
          'aisle': aisle,
          'count': details['count']?.toString() ?? '0',
          'timespent': details['timespent'] ?? '0',
          'percentage': '${details['percentage']?.toString() ?? '0'}%',
        };
      });

      final List<Map<String, dynamic>> updatedData = [];

      if (liveStoreAisleData.isNotEmpty) {
        for (var existingEntry in liveStoreAisleData) {
          final aisle = existingEntry['aisle'].toString();
          if (newData.containsKey(aisle)) {
            updatedData.add(newData[aisle]!);
            newData.remove(aisle);
          } else {
            updatedData.add(existingEntry);
          }
        }
      }

      updatedData.addAll(newData.values);

      liveStoreAisleData.value = updatedData;
      debugPrint('Updated live data: ${liveStoreAisleData.length} entries');
    } catch (e, stack) {
      debugPrint('Error processing aisle details: $e\n$stack');
    } finally {
      isProcessingData.value = false;
    }
  }

  Future<void> getFloormapByStoreId(int storeId, int page,
      {DateRangeType range = DateRangeType.sevenDays}) async {
    try {
      dateRangeVM.handleEnable(false);
      isLoadingHeatmap.value = true;
      final res = await APIController.to.request(
        await HeatmapRequest.fetchHeatmapFloorImage(
            storeId.toString(), page, range),
      );

      if (res.response?.statusCode == 200 && res.data != null) {
        if (res.data is String) {
          floormapBase64.value = res.data!;
          isLoadingHeatmap.value = false;
        } else {
          floormapBase64.value = '';
        }
      } else {
        floormapBase64.value = '';
        if (res.response?.data != null) {
          try {
            jsonDecode(res.response!.data.toString());
          } catch (e) {
            debugPrint('Failed to decode error data: $e');
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching heatmap: $e');
      debugPrint('Stack trace: $stackTrace');
      floormapBase64.value = '';
    } finally {
      isLoadingHeatmap.value = false;
      dateRangeVM.handleEnable(true);
    }
  }

  void updateLiveData(dynamic data) {
    if (isProcessingData.value) return;

    try {
      if (data == null) {
        debugPrint('Received null data in updateLiveData');
        return;
      }

      final aisleDetails = data['aisle_details'];
      if (aisleDetails != null) {
        _processAisleDetails(aisleDetails);
      } else {
        debugPrint('No aisle_details found in live data update');
      }
    } catch (e, stack) {
      debugPrint('Error updating live data: $e\n$stack');
    }
  }

  Future<void> getHeatImagesDataByStoreId(int storeId, int page,
      {DateRangeType range = DateRangeType.sevenDays}) async {
    try {
      isLoadingHeatmap.value = true;

      final res = await APIController.to.request(
        await HeatmapRequest.fetchHeatmapImagesbyCamera(
          storeId.toString(), // Ensure the storeId is passed as a string
          page + 1,
          range,
        ),
      );

      if (res.response?.statusCode == 200 && res.data != null) {
        final dataList = res.data != null ? jsonDecode(res.data!) as List : [];
        if (dataList != null) {
          floormapImagesDataList.clear();
          floormapImagesDataList.addAll(
            dataList
                .map((imageUrl) => HeatmapData(imageUrl: imageUrl))
                .toList(),
          );
          debugPrint('Heatmap data: ${floormapImagesDataList.length} items');
        } else {
          floormapImagesDataList.clear();
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching heatmap data: $e');
      debugPrint('Stack trace: $stackTrace');
      floormapImagesDataList.clear();
    } finally {
      isLoadingHeatmap.value = false;
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}

class HeatmapData {
  final String imageUrl;

  HeatmapData({
    required this.imageUrl,
  });

  factory HeatmapData.fromJson(String imageUrl) {
    return HeatmapData(
      imageUrl: imageUrl,
    );
  }
}
