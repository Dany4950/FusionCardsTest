import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vms/controller/fcm_controller.dart';
import 'package:vms/presentation/dashboard/video_player_screen.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FcmController fcmController = Get.find();

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    _setupNotificationTapHandler();
  }

  Future<void> initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    await _requestNotificationPermission();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
          ),
        ),
        payload: message.data['videoUrl'], // Pass video URL as payload
      );
    }
  }

  void _setupNotificationTapHandler() {
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification tapped: ${details.payload}');
        if (details.payload != null && details.payload!.isNotEmpty) {
          Get.to(() => VideoPlayerScreen(videoUrl: details.payload!));
        }
      },
    );

    // Handle notifications that opened the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint('Message data: ${message.data.toString()}');
      final videoUrl = message.data['videoUrl'];
      if (videoUrl != null && videoUrl.isNotEmpty) {
        Get.to(() => VideoPlayerScreen(videoUrl: videoUrl));
      }
    });
  }

  Future<void> _requestNotificationPermission() async {
    try {
      if (!await _isRealDevice()) {
        debugPrint('APNS Token: Not available on simulator');
        return;
      }

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      String currentFCMToken = await fcmController.getFCMToken();
      debugPrint('Current FCM Token: $currentFCMToken');

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token Refreshed: $newToken');
        fcmController.sendTokenToBackend(newToken);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('A new onMessageOpenedApp event was published!');
      });
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }
  }

  Future<bool> _isRealDevice() async {
    if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      return deviceInfo.isPhysicalDevice;
    } else if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.isPhysicalDevice;
    }
    return false;
  }
}
