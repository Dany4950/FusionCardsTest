import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/stores_tabbar.dart';

import 'date_range_selector.dart';

class StoresDateTabBars extends StatelessWidget {
  StoresDateTabBars({
    super.key,
    this.isKitchenScreen = false,
    this.shouldShowLive = true,
    this.shouldShowDateRangeLive = false,
    this.isHeatmapScreen = false,
  });

  final VMStores vmStores = Get.find();
  final VMPeopleCount vmPeopleCount = Get.find();
  final bool isKitchenScreen;
  final bool shouldShowLive;
  final bool shouldShowDateRangeLive;
  final bool isHeatmapScreen;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoresTabBar(
              isKitchenScreen: isKitchenScreen,
              shouldShowLive: isHeatmapScreen ? false : shouldShowLive,
            ),
            Transform.translate(
              offset: Offset(0, -1),
              child: Divider(
                color: Colors.grey[300],
                height: 1,
              ),
            ),
            if (!vmStores.isLiveSelected) const Gap(10),
            if (!vmStores.isLiveSelected)
              Obx(() {
                final _ = vmPeopleCount.isShowForecastEnabled
                    .value; 
                return DateRangeSelector(
                  shouldShowLive: shouldShowDateRangeLive,
                  isHeatmap: isHeatmapScreen,
                );
              }),
          ],
        ));
  }
}
