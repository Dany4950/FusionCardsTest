import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/fonts.dart';
import 'package:vms/common/images.dart';
import 'package:vms/utils/widgets/common_widget.dart';

class CustomTabBar<T> extends StatelessWidget {
  final List<T> list;
  final bool Function(int) checkIsActive;
  final String Function(T) getTitle;
  final Function(int) onTap;
  final bool hideImage;
  final bool isExpanded;

  const CustomTabBar(this.list, this.checkIsActive, this.getTitle, this.onTap,
      {super.key, this.hideImage = false, this.isExpanded = false});

  Widget getItem(T store, bool isActive, index) {
    return Padding(
      padding: EdgeInsets.only(right: isExpanded ? 0 : 30.0),
      child: GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: isActive
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
              if (!hideImage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Image(
                    image: AssetImage(
                      isActive ? "active_home".png : "home".png,
                    ),
                    width: 20,
                  ),
                ),
              Text(
                getTitle(store),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: Weight.medium,
                  fontFamily: AppFonts.inter,
                  color: isActive
                      ? AppColors.darkBlue
                      : AppColors.black.withOpacity(0.5),
                ),
              ),
              Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (isExpanded)
          Obx(
            () => Row(
              children: list.asMap().entries.map((entry) {
                final index = entry.key;
                final store = entry.value;
                final isActive = checkIsActive(index);
                return Expanded(
                  child: Center(
                    child: getItem(store, isActive, index),
                  ),
                );
              }).toList(),
            ),
          ),
        if (!isExpanded)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Obx(
                () => Row(
                  children: list.asMap().entries.map((entry) {
                    final index = entry.key;
                    final store = entry.value;
                    final isActive = checkIsActive(index);
                    return getItem(store, isActive, index);
                  }).toList(),
                ),
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