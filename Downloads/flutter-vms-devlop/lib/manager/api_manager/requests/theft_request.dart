import 'package:intl/intl.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/theft/m_theft_trends.dart';
import '../../../data/theft/thefts_list_data.dart';
import '../../../data/theft_details.dart';
import '../api_controller.dart';
import '../url.dart';
import 'm_adapter.dart';

abstract class TheftRequest {
  static APIInput<MAdapter<TheftsItem>> theftDetectionDetails(
      String storeId, int page, DateRangeType range) {
    String days;
    switch (range) {
      case DateRangeType.yesterday:
        days = 'custom';
        break;
      case DateRangeType.lastWeek:
        days = '7';
        break;
      case DateRangeType.lastMonth:
        days = '30';
        break;
      case DateRangeType.lastYear:
        days = 'year';
        break;
      default:
        days = 'year';
    }
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => TheftsItem.fromJson(data)),
      endPoint: "${EndPoint.theftDetectionDetails}/$storeId",
      type: APIType.getQuery,
      headers: {
        'Datetype': days,
        'Startdate': days == "custom"
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: 1)))
            : DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'Enddate':
            DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(
                days: days == 'year'
                    ? 365
                    : days == "custom"
                        ? 1
                        : int.parse(days)))),
      },
    );
  }

  static APIInput<MAdapter<TheftsListItemData>> getTheftListByStoreId(
      String storeId, int page, DateRangeType range,
      {bool isLive = false}) {
    int days;
    switch (range) {
      case DateRangeType.yesterday:
        days = 1;
        break;
      case DateRangeType.lastWeek:
        days = 7;
        break;
      case DateRangeType.lastMonth:
        days = 30;
        break;
      case DateRangeType.lastYear:
        days = 365;
        break;
      default:
        days = 7;
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String start =
        formatter.format(DateTime.now().subtract(Duration(days: days)));
    final String end = formatter.format(DateTime.now());
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => TheftsListItemData.fromJson(data)),
      endPoint:
          "${EndPoint.theftListBasedOnStoreId}/$storeId/$start/$end/1/100",
      type: APIType.getQuery,
      headers: {
        if (isLive) 'Live': true,
      },
    );
  }

  static APIInput<MAdapter<MTheftTrends>> theftTrendsOfAllTime(
      String storeId, int page, DateRangeType range) {
    int days;
    switch (range) {
      case DateRangeType.yesterday:
        days = 1;
        break;
      case DateRangeType.lastWeek:
        days = 7;
        break;
      case DateRangeType.lastMonth:
        days = 30;
        break;
      case DateRangeType.lastYear:
        days = 365;
        break;
      default:
        days = 30;
    }
    var start = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: days)));
    var end = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => MTheftTrends.fromJson(data)),
      endPoint: "${EndPoint.theftTrendsOfAllTime}/$storeId/$start/$end",
      type: APIType.getQuery,
    );
  }
}
