import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/fonts.dart';
import 'package:vms/common/images.dart';
import 'package:vms/presentation/dashboard/stores/stores_screen.dart';
import 'package:vms/presentation/notification/notification_screen.dart';
import 'package:vms/presentation/profile/profile_screen.dart';
import 'package:vms/controller/route_controller.dart';

class MoksaNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isNeedBack;
  final bool hideTrailing;
  final Widget? trailingWidget;

  @override
  final Size preferredSize;

  const MoksaNavBar(
    this.title, {
    this.isNeedBack = false,
    this.hideTrailing = false,
    super.key,
    this.trailingWidget,
  }) : preferredSize = const Size.fromHeight(52.0);

  @override
  Widget build(BuildContext context) {
    RouteController rc = Get.find();

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.white,
      leading: isNeedBack
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onPressed: () {
                  rc.popScreen();
                },
              ),
            )
          : null,
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: Weight.semiBold,
              fontFamily: AppFonts.inter,
            ),
          ),
          if (trailingWidget != null) trailingWidget!,
        ],
      ),
      centerTitle: false,
      elevation: 0,
      actions: hideTrailing
          ? []
          : [
              IconButton(
                icon: ImageIcon(AssetImage("store".png)),
                onPressed: () {
                  rc.pushScreen(StoresScreen());
                },
              ),
              IconButton(
                  onPressed: () => rc.pushScreen(NotificationScreen()),
                  icon: Icon(Icons.notifications)),
              IconButton(
                icon: ImageIcon(AssetImage("profile".png)),
                onPressed: () {
                  rc.pushScreen(ProfileSettingsPage());
                },
              ),
            ],
    );
  }
}
