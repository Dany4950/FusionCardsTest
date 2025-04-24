import 'package:get/get.dart';
import 'package:vms/controller/fcm_controller.dart';
import 'package:vms/controller/route_controller.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/controller/notification_controller.dart';
import 'package:vms/presentation/notification/vm_notification.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/services/employee_images_service.dart';

import '../manager/api_manager/api_controller.dart';
import '../presentation/dashboard/employee_efficiency/vm_employee_efficiency.dart';
import '../presentation/dashboard/kitchen_safety/vm_kitchen_safety.dart';
import '../presentation/dashboard/people_count/vm_people_count.dart';
import '../presentation/dashboard/theft/vm_theft.dart';
import '../presentation/profile/vm_profile.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(VMDateRange());
    Get.put(VMPeopleCount());
    Get.put(RouteController());
    Get.put(APIController());
    Get.put(FcmController());
    Get.put(VMTheft());

    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => VMStores(), fenix: true);
    Get.lazyPut(() => VMEmployeeEfficiency(), fenix: true);
    Get.lazyPut(() => VMKitchenSafety(), fenix: true);
    Get.lazyPut(() => VMProfile(), fenix: true);
    Get.lazyPut(() => VMHeatmap(), fenix: true);
    Get.lazyPut(() => VMNotification(), fenix: true);
    Get.lazyPut(() => EmployeeImageCacheService(), fenix: true);
  }
}
