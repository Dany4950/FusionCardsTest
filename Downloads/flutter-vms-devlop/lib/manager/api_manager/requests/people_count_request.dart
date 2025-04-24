import 'package:vms/data/people_count/people_count_live_response.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

import '../../../data/people_count_history_data.dart';
import '../api_controller.dart';
import '../url.dart';
import 'm_adapter.dart';

abstract class PeopleCountRequest {
  static Future<APIInput<MAdapter<PeopleCountHistoryItem>>> getPeopleCount(
      String storeId, String pageNumber, DateRangeType range,
      {bool isDropDown = false}) async {
    return APIInput(
      model: (json) => MAdapter.fromJson(
          json, (data) => PeopleCountHistoryItem.fromJson(data)),
      endPoint: "${EndPoint.getPeopleCount}/$storeId",
      type: APIType.getQuery,
      headers: {
        'datetype': range.value,
        'pagenumber': pageNumber,
        'pagepersize': '20',
        'dropdown': isDropDown.toString(),
      },
    );
  }

  static APIInput<MAdapter<StorePeopleCountData>> getPeopleCountLive(
      String storeId, String pageNumber,
      {bool isDropDown = false}) {
    return APIInput(
      model: (json) => MAdapter.fromJson(
          json, (data) => StorePeopleCountData.fromJson(data)),
      endPoint: "${EndPoint.getPeopleCountLive}/$storeId/$pageNumber/30",
      type: APIType.getQuery,
      headers: {
        'dropdown': isDropDown.toString(),
      },
    );
  }

  static APIInput getCustomerForecast(String storeId, DateRangeType type) {
    if (type == DateRangeType.tommorrow || type == DateRangeType.today) {
      return APIInput<List<BusyHourProjection>>(
        model: (json) => (json['data'] as List)
            .map((item) => BusyHourProjection.fromJson(item))
            .toList(),
        endPoint: "${EndPoint.getCustomerProjections}/$storeId/${type.value}",
        type: APIType.getQuery,
      );
    } else if (type == DateRangeType.nextWeek ||
        type == DateRangeType.nextMonth) {
      return APIInput<WeeklyForecastResponse>(
        model: (json) => WeeklyForecastResponse.fromJson(json),
        endPoint: "${EndPoint.getCustomerProjections}/$storeId/${type.value}",
        type: APIType.getQuery,
      );
    } else {
      throw Exception('Invalid type parameter');
    }
  }
}
