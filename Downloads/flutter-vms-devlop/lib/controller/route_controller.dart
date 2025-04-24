import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vms/manager/utils.dart';
import 'package:vms/presentation/dashboard/heatmap/heatmap_screen.dart';
import 'package:vms/presentation/dashboard/live/live_screen.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/dashboard/video_player_screen.dart';
import 'package:vms/utils/screen_type.dart';

import '../presentation/dashboard/dashboard_sceen.dart';
import '../presentation/dashboard/employee_efficiency/employee_efficiency_screen.dart';
import '../presentation/dashboard/kitchen_safety/kitchen_safety_screen.dart';
import '../presentation/dashboard/people_count/people_count_screen.dart';
import '../presentation/dashboard/theft/theft_screen.dart';

class RouteController extends GetxController {
  static RouteController get to => Get.find();

  VMPeopleCount vmPeopleCount = Get.find();

  late String? videoUrl;
  RxInt currentIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    videoUrl = SessionManager.getString(SessionManager.initialUrl);
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      SessionManager.remove(SessionManager.initialUrl);
      currentScreen.value = MScreenType.video;
    }
    changeScreen(currentScreen.value);
  }

  final currentScreen = MScreenType.dashboard.obs;

  RxList<Widget> screens = RxList([]);

  pushScreen(Widget screen) {
    screens.add(screen);
    screens.refresh();
  }

  popAll() {
    screens.value = [screens.first];
    screens.refresh();
  }

  _clearAndPush(screen) {
    screens.value = [screen];
    screens.refresh();
  }

  popScreen() {
    if (screens.length > 1) {
      screens.removeLast();
    } else {
      debugPrint("Final screen");
    }

    screens.refresh();
  }

  changeScreen(MScreenType screenType) {
    currentScreen.value = screenType;

    vmPeopleCount.isShowForecastEnabled.value =
        screenType == MScreenType.people;

    switch (screenType) {
      case MScreenType.dashboard:
        _clearAndPush(const DashboardScreen());
      case MScreenType.efficiency:
        _clearAndPush(const EmployeeEfficiencyScreen());
      case MScreenType.kitchen:
        _clearAndPush(const KitchenSafetyScreen());
      case MScreenType.people:
        _clearAndPush(const PeopleCountScreen());
      case MScreenType.theft:
        _clearAndPush(const TheftScreen());
      case MScreenType.heatMap:
        _clearAndPush(const HeatmapScreen());
      case MScreenType.video:
        _clearAndPush(VideoPlayerScreen(videoUrl: videoUrl!));
      case MScreenType.live:
        _clearAndPush(const LiveScreen());
    }
  }
}
