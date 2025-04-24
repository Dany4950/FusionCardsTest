import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/presentation/widgets/moksa_bottom_navigation_bar.dart';
import 'package:vms/controller/notification_controller.dart';
import 'package:vms/utils/screen_type.dart';
import '../controller/route_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RouteController rc = Get.find();
  final NotificationController _notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(children: rc.screens.value),
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: AnimatedOpacity(
          opacity: 0.5,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              rc.changeScreen(MScreenType.live);
            },
            child: Image.asset(
              'assets/icons/live_icon.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
      bottomNavigationBar: MoksaBottomNavigationBar(),
    );
  }
}
