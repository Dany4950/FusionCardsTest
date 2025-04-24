import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vms/manager/api_manager/url.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/services/employee_images_service.dart';

Future<String?> getPresignedUrl(String url) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      '${BaseURL.baseURL}/generatePresignedUrl?key=$url',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AuthStorage().getAuthToken()}',
          'key': url
        },
      ),
    );

    debugPrint('pre $url');
    debugPrint('Presigned URL response: ${response.data}');

    if (response.statusCode == 200) {
      return response.data['data'] as String;
    }
    return null;
  } on DioException catch (e) {
    debugPrint('Error getting presigned URL: ${e.message}');
    return null;
  }
}

Future<String?> getPresignedEmpImageUrl(int id, String url) async {
  String? empImageUrl = EmployeeImageCacheService.to.getImageById(id);

  if (empImageUrl != null) return empImageUrl;

  empImageUrl = await getPresignedUrl(url);
  if (empImageUrl != null) {
    EmployeeImageCacheService.to.setImageById(id, empImageUrl);
  } else {
    debugPrint('Error: Presigned URL is null for employee ID: $id');
  }
  return empImageUrl;
}

extension DoubleYIntervalExtension on double {
  double get yInterval {
    if (this < 5) return 1;
    final interval = (truncateToDouble() / 5).ceilToDouble();
    return interval == 0 ? this : interval;
  }
}
