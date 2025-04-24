import 'package:get/get.dart';

class EmployeeImageCacheService extends GetxService {
  static EmployeeImageCacheService get to =>
      Get.find<EmployeeImageCacheService>();

  Map<int, String> employeeImages = {};

  String? getImageById(int id) => employeeImages[id];

  void setImageById(int id, String image) {
    employeeImages[id] = image;
  }
}
