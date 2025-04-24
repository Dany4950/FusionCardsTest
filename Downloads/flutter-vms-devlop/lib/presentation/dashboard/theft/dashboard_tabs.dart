import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../employee_efficiency/employee_efficiency_live.dart';
import '../kitchen_safety/kitchen_safety_live.dart';
import '../overview_cards.dart';

class DashboardTabs extends StatelessWidget {
  RxInt selectedIndex;

  DashboardTabs(this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (selectedIndex.value == 0) {
        return OverviewCards(
          storeId: -1,
          titles: const ['Stores Assigned', 'Cameras Assigned', "", ""],
          isDashboardScreen: false,
          isGreyBox: true,
        );
      } else if (selectedIndex.value == 1) {
        return EmployeeEfficiencyLiveWidget(-1, isForDashboard: true);
      } else {
        return KitchenSafetyLiveWidget(-1, isFromDashboard: true);
      }
    });
  }
}
