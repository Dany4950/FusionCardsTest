import '../../manager/api_manager/api_controller.dart';

class ParamLogin implements Paramable {
  ParamLogin({
    required this.email,
    required this.password,
  });

  final String? email;
  final String? password;

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
