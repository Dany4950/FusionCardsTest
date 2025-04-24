import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/overview_cards.dart';
import 'package:vms/presentation/dashboard/theft/dashboard_tabs.dart';
import 'package:vms/presentation/dashboard/theft/theft_trends_widget.dart';
import 'package:vms/presentation/dashboard/theft/thefts_chart.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';

import '../widgets/dashboard_tabbar.dart';
import '../widgets/date_range_selector.dart';

class DashboardScreen extends StatelessWidget {
  static const String title = 'Dashboard';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VMDateRange dateRangeVM = Get.find();
    RxInt selectedTab = RxInt(0);
    return Scaffold(
      appBar: const MoksaNavBar("Dashboard"),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OverviewCards(
                storeId: -1,
                titles: const [
                  'Stores Assigned',
                  'Cameras Assigned',
                  'Thefts Detected',
                  'Thefts Prevented'
                ],
              ),
              Gap(14),
              TheftsDetectedChart(
                storeId: '-1',
                range: dateRangeVM.selectedDate.value,
              ),
              const SizedBox(height: 16),
              const TheftTrendsWidget(storeId: '-1'),
              const SizedBox(height: 16),
              DashboardTabBar(selectedTab),
              const SizedBox(height: 16),
              DashboardTabs(selectedTab),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
