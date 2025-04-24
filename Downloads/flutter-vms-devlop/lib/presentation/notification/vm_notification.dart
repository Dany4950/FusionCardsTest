import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vms/data/login_data.dart';
import 'package:vms/data/notification_data.dart';
import 'package:vms/manager/api_manager/api_controller.dart';
import 'package:vms/manager/api_manager/requests/notification_request.dart';
import 'package:vms/manager/api_manager/url.dart';
import 'package:vms/services/auth_service.dart';
import 'package:flutter/material.dart';

class VMNotification extends GetxController {
  static VMNotification get to => Get.find();

  final RxList<NotificationModel> notifications =
      <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  IO.Socket? socket;

  @override
  void onInit() {
    super.onInit();
    initializeSocket();
    fetchNotifications();
  }

  void initializeSocket() {
    User? authData = AuthStorage.to.getUserData();
    if (authData == null) return;

    socket = IO.io(BaseURL.socketBaseURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.onConnect((_) {
      debugPrint('Notification Socket Connected');
      socket?.emit('joinUser', authData.id);
    });

    socket?.on('notification_${authData.id}', (data) {
      handleNewNotification(data);
    });

    socket?.onDisconnect(
        (_) => debugPrint('Notification Socket Disconnected'));
  }

  void handleNewNotification(Map<String, dynamic> data) {
    try {
      NotificationModel newNotification =
          NotificationModel.fromJson(data);
      notifications.insert(0, newNotification);
    } catch (e) {
      debugPrint('Error handling new notification: $e');
    }
  }

  Future<void> fetchNotifications() async {
    try {
      int userId = AuthStorage.to.getUserData()?.id ?? -1;
      isLoading.value = true;
      final res = await APIController.to.request(
        NotificationRequest.fetchNotifications(userId),
      );

      if (res.isSuccess && res.data != null) {
        notifications.assignAll(res.data?.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }
}
