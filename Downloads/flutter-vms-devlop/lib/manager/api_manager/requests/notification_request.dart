import 'package:vms/data/notification_data.dart';
import 'package:vms/manager/api_manager/api_controller.dart';
import 'package:vms/manager/api_manager/url.dart';

abstract class NotificationRequest {
  static APIInput<NotificationData> fetchNotifications(int id) {
    return APIInput(
      model: (json) => NotificationData.fromJson(json),
      endPoint: "${EndPoint.getNotifications}/$id",
      type: APIType.getQuery,
    );
  }
}