import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/controller/route_controller.dart';
import 'package:vms/utils/screen_type.dart';
import 'package:vms/utils/widgets/common_widget.dart';

class MoksaBottomNavigationBar extends StatelessWidget {
  final RouteController rc = Get.find();

  MoksaBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.moksaBlue,
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: MScreenType.bottomNavScreens()
                .map(
                  (screen) => Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Obx(
                          () => Material(
                            color: screen == rc.currentScreen.value
                                ? AppColors.lightBlue
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () => rc.changeScreen(screen),
                              child: Ink(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    ImageIcon(
                                      AssetImage(screen.iconPath),
                                      color: screen ==
                                              rc.currentScreen.value
                                          ? AppColors.white
                                          : AppColors.white
                                              .withOpacity(0.6),
                                    ),
                                    const Gap(2),
                                    getText(
                                      screen.title,
                                      fontSize: 11,
                                      fontColor: AppColors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
