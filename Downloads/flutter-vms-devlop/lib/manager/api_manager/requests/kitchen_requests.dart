import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vms/manager/api_manager/requests/m_adapter.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/kitchen_safety_data.dart';
import '../api_controller.dart';
import '../url.dart';

abstract class KitchenRequests {
  static APIInput<MAdapter<KitchenSafetyMain>> fetchSafety(
      int storeId, int pageNo, DateRangeType range,
      {bool isLive = false}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    final String endDate;
    switch (range) {
      case DateRangeType.yesterday:
        endDate = formatter
            .format(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case DateRangeType.lastWeek:
        endDate = formatter
            .format(DateTime.now().subtract(const Duration(days: 7)));
        break;
      case DateRangeType.lastMonth:
        endDate = formatter.format(
            DateTime.now().subtract(const Duration(days: 30)));
        break;
      case DateRangeType.lastYear:
        endDate = formatter.format(
            DateTime.now().subtract(const Duration(days: 365)));
        break;
      default:
        endDate = formatter
            .format(DateTime.now().subtract(const Duration(days: 7)));
    }
    return APIInput(
        model: (json) => MAdapter.fromJson(
            json, (data) => KitchenSafetyMain.fromJson(data)),
        endPoint:
            "${EndPoint.getSafetyDetails}/$storeId/$pageNo/${isLive ? 30 : 10}/$endDate/$startDate",
        type: APIType.getQuery,
        headers: {
          if (isLive) "Live": true,
        });
  }

  static APIInput<MAdapter<KitchenSafetyMain>> fetchLiveSafety(
      int storeId, int pageNo) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    return APIInput(
      model: (json) => MAdapter.fromJson(
          json, (data) => KitchenSafetyMain.fromJson(data)),
      endPoint:
          "${EndPoint.getSafetyDetails}/$storeId/$pageNo/30/$startDate/$startDate",
      type: APIType.getQuery,
      headers: {
        "Live": true,
      },
    );
  }

  static APIInput fetchKitchenImage(String imageUrl) {
    return APIInput(
      model: (json) => json,
      endPoint: EndPoint.stream,
      type: APIType.postParam,
      responseType: ResponseType.bytes,
      parameter: {
        "key": imageUrl,
      },
    );
  }
}
