import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';

class AisleDataGrid extends StatefulWidget {
  final int storeId;
  final bool isLive;
  const AisleDataGrid(
      {super.key, required this.storeId, required this.isLive});

  @override
  State<AisleDataGrid> createState() => AisleDataGridState();
}

class AisleDataGridState extends State<AisleDataGrid> {
  final VMHeatmap vmHeatmap = Get.find<VMHeatmap>();
  RxString error = RxString('');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error.value),
            ],
          ),
        );
      }

      final data = widget.isLive
          ? vmHeatmap.liveStoreAisleData
          : vmHeatmap.storeAisleData;

      if (data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No data available'),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 2.0, left: 4.0, right: 4.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.2,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              if (item == null) return const SizedBox.shrink();

              return Card(
                elevation: 0.0,
                color: Colors.grey[200],
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['aisle']}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16),
                          const SizedBox(width: 4),
                          Text('${item['count'] ?? 0}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                              '${item['timespent'].split(' ')[0] ?? '0'}'),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '${item["percentage"] ?? 0}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
