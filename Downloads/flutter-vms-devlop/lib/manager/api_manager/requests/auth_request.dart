import '../../../data/login_data.dart';
import '../../../data/param/auth_param.dart';
import '../api_controller.dart';
import '../url.dart';
import 'm_adapter.dart';

abstract class AuthRequest {
  static APIInput<MAdapter<UserData>> login(ParamLogin param) {
    return APIInput(
      model: (json) =>
          MAdapter.fromJson(json, (data) => UserData.fromJson(data)),
      endPoint: EndPoint.login,
      type: APIType.postParam,
      parameter: param,
    );
  }
}
