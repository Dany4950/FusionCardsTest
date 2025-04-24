import '../api_controller.dart';
import '../url.dart';
import 'm_adapter.dart';

abstract class FcmRequest {
  static APIInput<MAdapter> updateToken(String newToken, String oldToken) {
    return APIInput(
      model: (json) => MAdapter.fromJson(json, (data) => data),
      endPoint: EndPoint.updateFcmToken,
      type: APIType.postParam,
      parameter: {
        "newToken": newToken,
        "oldToken": oldToken,
      },
    );
  }

  static APIInput<MAdapter> removeToken(String token) {
    return APIInput(
      model: (json) => MAdapter.fromJson(json, (data) => data),
      endPoint: EndPoint.removeFcmToken,
      type: APIType.postParam,
      parameter: {
        "oldToken": token,
      },
    );
  }
}
