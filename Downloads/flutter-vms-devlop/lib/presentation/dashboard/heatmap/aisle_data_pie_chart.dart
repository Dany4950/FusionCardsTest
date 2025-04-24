import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';

class AisledataPieChart extends StatefulWidget {
  final int storeId;
  final bool isLive;

  const AisledataPieChart(
      {super.key, required this.storeId, required this.isLive});

  @override
  State<AisledataPieChart> createState() => _AisledataPieChartState();
}

class _AisledataPieChartState extends State<AisledataPieChart> {
  final VMHeatmap vmHeatmap = Get.put(VMHeatmap());
  TooltipBehavior? tooltipBehavior;

  @override
  void initState() {
    tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 1500,
      animationDuration: 500,
      tooltipPosition: TooltipPosition.pointer,
      shouldAlwaysShow: false,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data['aisle'].toString().toUpperCase(),
                style: TextStyle(
                  color: generateColors(
                      vmHeatmap.storeAisleData.length)[pointIndex],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data['percentage'].toString(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
    super.initState();
  }

  List<Color> generateColors(int count) {
    final List<Color> baseColors = [
      Colors.blue,
      Colors.yellow,
      Colors.red.shade300,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];

    return List.generate(count, (index) {
      Color baseColor = baseColors[index % baseColors.length];
      return HSLColor.fromColor(baseColor)
          .withLightness(0.3 + (0.3 * index / count))
          .withSaturation(0.7)
          .toColor()
          .withOpacity(0.8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
            child: Text(
              'Aisle Data Distribution',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final data = widget.isLive
                  ? vmHeatmap.liveStoreAisleData
                  : vmHeatmap.storeAisleData;

              if (data.isEmpty) {
                return const SizedBox.shrink();
              }

              final colors = generateColors(data.length);

              return SfCircularChart(
                tooltipBehavior: tooltipBehavior,
                series: <CircularSeries>[
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: data,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['aisle'].toString(),
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(
                            data['percentage'].toString().replaceAll('%', '')),
                    pointColorMapper: (Map<String, dynamic> data, int index) =>
                        colors[index],
                    dataLabelMapper: (Map<String, dynamic> data, _) =>
                        '${double.parse(data['percentage'].toString().replaceAll('%', '')).toStringAsFixed(1)}%',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    enableTooltip: true,
                    animationDuration: 1000,
                    explodeGesture: ActivationMode.singleTap,
                    explode: true,
                    explodeOffset: '2%',
                    radius: '70%',
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
