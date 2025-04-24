import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:vms/manager/api_manager/requests/m_adapter.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/employee_efficiency_data.dart';
import '../../../data/employee_efficiency_details.dart';
import '../api_controller.dart';
import '../url.dart';

abstract class EmpEfficiecyRequest {
  static Future<APIInput<MAdapter<EmployeeEfficiencyItem>>>
      getEmployeeEfficiencyByStoreid(
          String storeId, int pageNumber, DateRangeType range) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    String endDate;
    switch (range) {
      case DateRangeType.yesterday:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case DateRangeType.lastWeek:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 7)));
        break;
      case DateRangeType.lastMonth:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 30)));
        break;
      case DateRangeType.lastYear:
        endDate = formatter
            .format(DateTime.now().subtract(const Duration(days: 365)));
        break;
      default:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 7)));
    }

    return APIInput(
      model: (json) => MAdapter.fromJson(
          json, (data) => EmployeeEfficiencyItem.fromJson(data)),
      endPoint:
          "${EndPoint.getEmployeeEfficiencyByStoreidDynamic}/$storeId/$endDate/$pageNumber/10/$startDate",
      type: APIType.getQuery,
    );
  }

  static Future<APIInput<MAdapter<EmployeeData>>> employeeEfficiency(
      String employeeId, DateRangeType range) async {
    log("range $range");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    String endDate;
    switch (range) {
      case DateRangeType.live:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 0)));
        break;
      case DateRangeType.yesterday:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case DateRangeType.lastWeek:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 7)));
        break;
      case DateRangeType.lastMonth:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 30)));
        break;
      case DateRangeType.lastYear:
        endDate = formatter
            .format(DateTime.now().subtract(const Duration(days: 365)));
        break;
      default:
        endDate =
            formatter.format(DateTime.now().subtract(const Duration(days: 0)));
    }

    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => EmployeeData.fromJson(data)),
      endPoint:
          "${EndPoint.employeeEfficiency}/$employeeId/$endDate/$startDate",
      type: APIType.getQuery,
    );
  }

  static Future<APIInput<MAdapter<EmployeeEfficiencyItem>>>
      fetchLiveStoreEmployee(String storeId, int pageNumber) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    final String endDate = formatter.format(DateTime.now());

    return APIInput(
      model: (json) => MAdapter.fromJson(
          json, (data) => EmployeeEfficiencyItem.fromJson(data)),
      endPoint:
          "${EndPoint.getEmployeeEfficiencyByStoreidDynamic}/$storeId/$endDate/$pageNumber/30/$startDate",
      type: APIType.getQuery,
      headers: {
        "Live": true,
      },
    );
  }
}
