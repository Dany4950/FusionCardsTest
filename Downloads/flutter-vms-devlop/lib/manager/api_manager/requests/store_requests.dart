import 'package:intl/intl.dart';
import 'package:vms/manager/api_manager/requests/m_adapter.dart';

import '../../../data/all_store_details_data_by_id.dart';
import '../../../data/all_stores_data.dart';
import '../../../data/store_totals_data.dart';
import '../api_controller.dart';
import '../url.dart';

abstract class StoreRequest {
  static Future<APIInput<MAdapter<AllStoreDetailsItem>>> fetchStores(
      int storeId, int pageNo) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    final String endDate =
        formatter.format(DateTime.now().subtract(const Duration(days: 7)));
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => AllStoreDetailsItem.fromJson(data)),
      endPoint: "${EndPoint.getStores}/$storeId/$startDate/$endDate",
      type: APIType.getQuery,
      headers: {
        'pagenumber': pageNo,
        'pagepersize': 10,
      },
    );
  }

  static APIInput<MAdapter<StoreTotalsItem>> getAllStoresTotals(int storeId) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(DateTime.now());
    final String endDate =
        formatter.format(DateTime.now().subtract(const Duration(days: 7)));
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => StoreTotalsItem.fromJson(data)),
      endPoint: "${EndPoint.getAllStoresTotals}/$storeId/$endDate/$startDate",
      type: APIType.getQuery,
    );
  }

  static APIInput<MAdapter<StoresDDItem>> getAllStoresForDropdown() {
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => StoresDDItem.fromJson(data)),
      endPoint: EndPoint.getAllStoresForDropdown,
      headers: {'enableallstores': true},
      type: APIType.getQuery,
    );
  }
}
