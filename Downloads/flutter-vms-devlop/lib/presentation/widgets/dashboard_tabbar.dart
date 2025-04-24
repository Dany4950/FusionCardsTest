import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/fonts.dart';
import 'package:vms/utils/widgets/common_widget.dart';

class DashboardTabBar extends StatelessWidget {
  final RxInt selectedIndex;

  DashboardTabBar(this.selectedIndex, {super.key});

  final List<String> tabs = [
    "Stores",
    "Employee Efficiency",
    "Safety Protocol"
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(
              () => Row(
                  spacing: 20,
                  children: tabs
                      .map((item) => GestureDetector(
                            onTap: () {
                              selectedIndex.value = tabs.indexOf(item);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    selectedIndex.value == tabs.indexOf(item)
                                        ? Border(
                                            bottom: BorderSide(
                                              width: 2.5,
                                              color: AppColors.darkBlue,
                                            ),
                                          )
                                        : null,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: Weight.medium,
                                      fontFamily: AppFonts.inter,
                                      color: selectedIndex.value ==
                                              tabs.indexOf(item)
                                          ? AppColors.darkBlue
                                          : AppColors.black
                                              .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  Gap(8),
                                ],
                              ),
                            ),
                          ))
                      .toList()),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 1),
          child: divider,
        ),
      ],
    );
  }
}
