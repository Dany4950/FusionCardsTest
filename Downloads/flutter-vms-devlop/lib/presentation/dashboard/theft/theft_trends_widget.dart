import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/data/theft/m_theft_trends.dart';
import 'package:vms/presentation/dashboard/theft/trend_for_theft.dart';
import 'package:vms/presentation/dashboard/theft/vm_theft.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

class TheftTrendsWidget extends StatelessWidget {
  final String storeId;
  final bool isLive;

  const TheftTrendsWidget(
      {super.key, required this.storeId, this.isLive = false});

  @override
  Widget build(BuildContext context) {
    VMTheft vmTheft = Get.find();
    final VMDateRange dateRangeVM = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => FutureBuilder<List<MTheftTrends>?>(
              future: vmTheft.theftTrendsOfAllTime(
                storeId,
                1,
                range: isLive
                    ? DateRangeType.lastWeek
                    : dateRangeVM.selectedDate.value,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('No trend data available'),
                  );
                }

                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Gap(0);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trend for Theft',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomLineChart(data),
                  ],
                );
              },
            )),
      ],
    );
  }
}
