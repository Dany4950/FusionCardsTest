import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/fonts.dart';

import 'common_widget.dart';

class EmploytrackCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const EmploytrackCardWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getText(
                  title,
                  fontSize: 14,
                  fontColor: AppColors.black.withOpacity(0.6),
                ),
                Gap(10),
                getText(
                  value,
                  fontSize: 16,
                  fontWeight: Weight.semiBold,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.white,
                child: Icon(
                  icon,
                  color: Colors.indigo,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
