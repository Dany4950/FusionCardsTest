import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/controller/route_controller.dart';
import 'package:vms/presentation/notification/vm_notification.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/dashboard/video_player_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  VMNotification vmNotification = Get.find();
  RouteController rc = Get.find();

  @override
  void initState() {
    super.initState();
    vmNotification.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        rc.popScreen();
      },
      child: Scaffold(
        appBar: MoksaNavBar(
          "Notifications",
          isNeedBack: true,
          hideTrailing: true,
        ),
        backgroundColor: AppColors.white,
        body: _buildNotificationContent(),
      ),
    );
  }

  Widget _buildNotificationContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildNotificationList(),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return Expanded(
      child: Obx(() {
        if (vmNotification.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vmNotification.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('No notifications'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: vmNotification.notifications.length,
          itemBuilder: (context, index) {
            final notification = vmNotification.notifications[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: notification.videoUri ?? '',
                      key: ValueKey(notification.videoUri ?? ''),
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.darkBlue,
                    child: Image.asset(
                      'assets/images/moksa_logo.png',
                      height: 30,
                    ),
                  ),
                  title: const Text(
                    "Theft Detected!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Suspicious activity detected at ${notification.storeName}, "
                        "with probability of ${notification.theftProbability}",
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
