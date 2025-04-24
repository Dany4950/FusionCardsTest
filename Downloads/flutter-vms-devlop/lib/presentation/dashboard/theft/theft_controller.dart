import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../data/theft_details.dart';
import 'vm_theft.dart';

class TheftController extends GetxController {
  final VMTheft vmTheft = Get.find();
  final String storeId;
  final double barWidth = 7;

  RxList<BarChartGroupData> rawBarGroups = <BarChartGroupData>[].obs;
  RxList<BarChartGroupData> showingBarGroups = <BarChartGroupData>[].obs;
  RxInt touchedGroupIndex = (-1).obs;

  Rxn<List<TheftsItem>> theftDetails = Rxn<List<TheftsItem>>();
  RxBool isLoading = true.obs;
  Rxn<String> error = Rxn<String>();

  TheftController({required this.storeId});

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await vmTheft.getTheftDetectionDetailsByStoreId(
        storeId,
        30,
      );

      if (data != null) {
        theftDetails.value = data;
        processData();
      } else {
        error.value = 'Failed to load data';
      }
    } catch (e) {
      error.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void processData() {
    if (theftDetails.value == null) return;

    List<BarChartGroupData> items = [];

    for (int i = 0; i < theftDetails.value!.length; i++) {
      final theft = theftDetails.value![i];
      items.add(
        makeGroupData(
          i,
          theft.theftDetected,
          theft.theftPrevented,
        ),
      );
    }

    rawBarGroups.value = items;
    showingBarGroups.value = items;
  }

  void updateTouchedIndex(int? index, bool isInterested) {
    if (!isInterested || index == null) {
      touchedGroupIndex.value = -1;
      showingBarGroups.value = List.of(rawBarGroups);
      return;
    }

    touchedGroupIndex.value = index;
    updateBarGroups(index);
  }

  void updateBarGroups(int touchedIndex) {
    var newGroups = List.of(rawBarGroups);
    if (touchedIndex != -1) {
      var sum = 0.0;
      for (final rod in newGroups[touchedIndex].barRods) {
        sum += rod.toY;
      }
      final avg = sum / newGroups[touchedIndex].barRods.length;

      newGroups[touchedIndex] = newGroups[touchedIndex].copyWith(
        barRods: newGroups[touchedIndex].barRods.map((rod) {
          return rod.copyWith(toY: avg);
        }).toList(),
      );
    }
    showingBarGroups.value = newGroups;
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          width: barWidth,
        ),
        BarChartRodData(
          toY: y2,
          width: barWidth,
        ),
      ],
    );
  }

  double calculateMaxY() {
    if (theftDetails.value == null) return 0;

    double maxY = 0;
    for (var theft in theftDetails.value!) {
      double detected = theft.theftDetected;
      double prevented = theft.theftPrevented;
      maxY = [maxY, detected, prevented]
          .reduce((curr, next) => curr > next ? curr : next);
    }
    return maxY + (maxY * .2);
  }
}
