import '../../../data/user_details.dart';
import '../api_controller.dart';
import '../url.dart';
import 'm_adapter.dart';

abstract class ProfileRequest {
  static APIInput<MAdapter<PUserData>> getUserById(String id) {
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => PUserData.fromJson(data)),
      endPoint: "${EndPoint.getUserById}/$id",
      type: APIType.getQuery,
    );
  }

  static APIInput<MAdapter> createHelpRequest(String issue) {
    return APIInput(
      model: (json) => MAdapter.fromJson(json, (data) => data),
      endPoint: EndPoint.createHelp,
      type: APIType.postParam,
      parameter: {
        "issue": issue,
      },
    );
  }
}
