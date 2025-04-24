import 'package:flutter/material.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/images.dart';
import 'package:vms/services/auth_service.dart';

import '../../../data/kitchen_safety_data.dart';
import '../../../utils/widgets/common_widget.dart';

class KitchenSafetyDetails extends StatelessWidget {
  final KsEmployeeData employee;

  const KitchenSafetyDetails(this.employee);

  @override
  Widget build(BuildContext context) {
    // VMKitchenSafety vmKitchenSafety = Get.find();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        title: getText(
          employee.fullName,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: getNetworkImage(
              context,
              employee.imgLink.s3Url,
              header: {
                "Authorization": 'Bearer ${AuthService().getToken()}',
              },
              loadingProgress: true,
            ),
          ),
        ),
      ),
    );
  }
}
