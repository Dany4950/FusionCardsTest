import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';

import '../../data/store_totals.dart';

class OverviewCards extends StatefulWidget {
  final int storeId;
  final List<String> titles; // Add titles parameter
  final bool isDashboardScreen;
  final bool isGreyBox;

  const OverviewCards({
    super.key,
    required this.storeId,
    required this.titles,
    this.isDashboardScreen = true,
    this.isGreyBox = false,
  }) : assert(titles.length == 4,
            'Must provide exactly 4 titles'); // Add assertion

  @override
  State<OverviewCards> createState() => _OverviewCardsState();
}

class _OverviewCardsState extends State<OverviewCards> {
  StoreTotals storeTotals = StoreTotals.defaultValues();
  bool isLoading = true;
  String? error;
  VMStores vmStores = Get.find();

  @override
  void initState() {
    super.initState();
    fetchStoreTotals();
  }

  Future<void> fetchStoreTotals() async {
    try {
      final StoreTotals? result = await vmStores.getAllStoresTotals(-1);
      if (result != null) {
        setState(() {
          storeTotals = result;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to fetch data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget buildOverviewCard({
    required String title,
    required String value,
    required int cardIndex,
    String? efficiency,
  }) {
    LinearGradient _getCardGradient(int index) {
      switch (index) {
        case 0:
          return LinearGradient(colors: [
            AppColors.gb1,
            AppColors.gb2,
          ]);
        case 1:
          return LinearGradient(colors: [
            AppColors.gy1,
            AppColors.gy2,
          ]);
        case 2:
          return LinearGradient(colors: [AppColors.gsb2, AppColors.gsb1]);
        case 3:
          return LinearGradient(colors: [
            AppColors.gp1,
            AppColors.gp2,
          ]);
        default:
          return const LinearGradient(colors: [Colors.grey, Colors.blueGrey]);
      }
    }

    return Card(
      elevation: widget.isGreyBox ? 0 : 4,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isGreyBox ? AppColors.profilecardbg : null,
          gradient: widget.isGreyBox ? null : _getCardGradient(cardIndex),
          // Set gradient based on index
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: widget.isGreyBox
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: widget.isGreyBox ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (efficiency != null)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 3.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_graph,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            efficiency,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                fetchStoreTotals();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildOverviewCard(
                title: widget.titles[0],
                value: storeTotals.totalStores.toString(),
                cardIndex: 0,
                efficiency: null,
              ),
            ),
            Expanded(
              child: buildOverviewCard(
                title: widget.titles[1],
                value: storeTotals.totalCameras.toString(),
                cardIndex: 1,
                efficiency: null,
              ),
            ),
          ],
        ),
        if (widget
            .isDashboardScreen) // Add condition to show only on dashboard screen
          Row(
            children: [
              Expanded(
                child: buildOverviewCard(
                  title: widget.titles[2],
                  value: storeTotals.theftsDetected.toString(),
                  cardIndex: 2,
                  efficiency: null,
                ),
              ),
              Expanded(
                child: buildOverviewCard(
                  title: widget.titles[3],
                  value: storeTotals.theftsPrevented.toString(),
                  cardIndex: 3,
                  efficiency: null,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
