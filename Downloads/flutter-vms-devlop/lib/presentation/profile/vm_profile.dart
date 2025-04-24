import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vms/manager/api_manager/requests/profile_request.dart';
import 'package:vms/manager/loading_manager.dart';

import '../../data/user_details.dart';
import '../../manager/api_manager/api_controller.dart';
import '../../manager/utils.dart';

class VMProfile extends GetxController {
  LoadingManager createHelpLM = LoadingManager();
  final TextEditingController helpQueryController = TextEditingController();

  Future createHelpRequest() async {
    if (helpQueryController.text.trim().isNotEmpty) {
      final res = await APIController.to.request(
        ProfileRequest.createHelpRequest(helpQueryController.text),
        loadManager: createHelpLM,
      );

      if (res.isSuccess) {
        helpQueryController.clear();
      }
      showToast("Thanks for your query! We will get back to you soon.");
    } else {
      showToast("Please enter your queries!");
    }
  }

  Future<PUserData?> getUserByUserId(int userId) async {
    final res = await APIController.to.request(
      ProfileRequest.getUserById(userId.toString()),
    );

    if (res.isSuccess) {
      PUserData? data = res.data?.dataModel;
      return data;
    } else {
      return null;
    }
  }
}
