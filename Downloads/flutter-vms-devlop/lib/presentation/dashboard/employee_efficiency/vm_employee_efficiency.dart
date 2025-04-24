import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/manager/api_manager/requests/emp_efficiecy_request.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/employee_efficiency_data.dart';
import '../../../data/employee_efficiency_details.dart';
import '../../../manager/api_manager/api_controller.dart';

class VMEmployeeEfficiency extends GetxController {
  RxnInt currentPage = RxnInt(0);
  final PagingController<int, EmployeeEfficiencyItemData> pagingController =
      PagingController(firstPageKey: 0);
  final VMDateRange dateRangeVM = Get.find();
  RxList<EmployeeEfficiencyItemData> liveEmpEff = RxList();

  // New live paging controller for live data
  final PagingController<int, EmployeeEfficiencyItemData> livePagingController =
      PagingController(firstPageKey: 0);

  Future getEmployeeEfficiencyByStoreid(int storeId, int page,
      {DateRangeType range = DateRangeType.lastWeek}) async {
    final pageKey = page + 1;
    try {
      dateRangeVM.handleEnable(false);
      final res = await APIController.to.request(
        await EmpEfficiecyRequest.getEmployeeEfficiencyByStoreid(
            storeId.toString(), pageKey, range),
      );

      if (res.isSuccess) {
        EmployeeEfficiencyItem? data = res.data?.dataModel;
        List<EmployeeEfficiencyItemData> mainData = data?.data ?? [];
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

  // New method to page live data
  Future<void> getPagedLiveEmployeeEfficiencyByStoreid(int storeId, int page,
      {int pageSize = 30}) async {
    if (page == 0) {
      livePagingController.itemList?.clear();
    }
    final pageKey = page + 1;
    try {
      dateRangeVM.handleEnable(false);
      final res = await APIController.to.request(
        await EmpEfficiecyRequest.fetchLiveStoreEmployee(
            storeId.toString(), pageKey),
      );

      if (res.isSuccess) {
        EmployeeEfficiencyItem? data = res.data?.dataModel;
        List<EmployeeEfficiencyItemData> mainData = data?.data ?? [];
        bool isLastPage = mainData.length < pageSize;
        if (isLastPage) {
          livePagingController.appendLastPage(mainData);
        } else {
          livePagingController.appendPage(mainData, pageKey);
        }
      } else {
        livePagingController.error = res.message;
      }
    } catch (e) {
      livePagingController.error = e;
    } finally {
      dateRangeVM.handleEnable(true);
    }
  }

  Future<List<EmployeeData>?> getEmployeeEfficiencyByEmpid(int employeeId,
      {DateRangeType range = DateRangeType.yesterday}) async {
    dateRangeVM.handleEnable(false);
    final res = await APIController.to.request(
      await EmpEfficiecyRequest.employeeEfficiency(
          employeeId.toString(), range),
    );

    dateRangeVM.handleEnable(true);
    if (res.isSuccess) {
      List<EmployeeData>? data = res.data?.dataModels;
      return data;
    } else {
      debugPrint('Error fetching employee efficiency: ${res.message}');
      return null;
    }
  }


  Future<bool> getLiveEmployeeEfficiencyByStoreid(int storeId) async {
    dateRangeVM.handleEnable(false);
    
    final res = await APIController.to.request(
      await EmpEfficiecyRequest.fetchLiveStoreEmployee(storeId.toString(), 1),
    );

    dateRangeVM.handleEnable(true);

    if (res.isSuccess) {
      liveEmpEff.value = res.data?.dataModel?.data ?? [];
      return true;
    } else {
      pagingController.error = res.message;
      return false;
    }
  }
}
