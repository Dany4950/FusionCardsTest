import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:vms/manager/api_manager/url.dart';

import '../../services/auth_service.dart';
import '../loading_manager.dart';
import '../utils.dart';

class APIController extends GetxController {
  static APIController get to => Get.find();
  final _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger());
    }
  }

  Future<APIOutput<T>> request<T>(APIInput<T> input,
      {LoadingManager? loadManager}) async {
    loadManager?.showLoading();
    final url = '${BaseURL.baseURL}/${input.endPoint}';
    Object? data;
    Options? options;
    final headers = input.headers;
    debugPrint(headers.toString());

    updateData() {
      if (input.parameter is Map) {
        data = input.parameter;
      } else {
        data = (input.parameter as Paramable).toJson();
      }
      if (input.isFormData) {
        data = FormData.fromMap(data as Map<String, dynamic>);
      }
    }

    switch (input.type) {
      case APIType.postParam:
        updateData();
        options = Options(
          method: 'POST',
          responseType: input.responseType,
          contentType: 'application/json',
          headers: headers,
          receiveTimeout: Duration(seconds: 5),
        );
        break;
      case APIType.putParam:
        updateData();
        options = Options(
          responseType: input.responseType,
          method: 'PUT',
          contentType: 'application/json',
          headers: headers,
          receiveTimeout: Duration(seconds: 5),
        );
        break;
      case APIType.delete:
        options = Options(
          responseType: input.responseType,
          method: 'DELETE',
          contentType: 'application/json',
          headers: headers,
          receiveTimeout: Duration(seconds: 5),
        );
        break;

      case APIType.putParam:
        if (input.parameter is Map) {
          data = input.parameter;
        } else {
          data = (input.parameter as Paramable).toJson();
        }
        options = Options(
          method: 'PUT',
          responseType: input.responseType,
          contentType: 'application/json',
          headers: headers,
          receiveTimeout: Duration(seconds: 5),
        );

        break;

      default:
        options = Options(
          method: 'GET',
          responseType: input.responseType,
          headers: headers,
          receiveTimeout: Duration(seconds: 5),
        );
    }
    APIOutput<T>? output;
    try {
      final res = await _dio.request(url, data: data, options: options);
      final model = input.model(res.data);
      output = APIOutput(
        data: model,
        response: res,
      );
    } on DioException catch (error) {
      String errorMsg = "Something went wrong! Please try again later.";
      output = APIOutput(data: null, response: error.response, error: error);
      if (error.toString().contains("timeout")) {
        showToast(errorMsg);
      } else if (error.response?.statusCode == 401) {
        AuthService().logout(statusCode: 401);
      } else if (error.response?.statusCode == 422) {
        Map<String, dynamic> jsonObject = error.response?.data;
        var errMsg;
        jsonObject.forEach((key, value) {
          List arr = value;
          if (arr.isNotEmpty) {
            errMsg = value[0];
          }
        });
        output = APIOutput(
            data: null,
            error:
                DioException(error: errMsg, requestOptions: RequestOptions()));
      }
    } catch (error) {
      output = APIOutput(
          data: null,
          error: DioException(error: error, requestOptions: RequestOptions()));
    } finally {
      loadManager?.hideLoading();
    }
    return output;
  }
}

enum APIType {
  getQuery,
  postQuery,
  postParam,
  putParam,
  delete,
}

class APIInput<T> {
  final T? Function(dynamic json) model;
  dynamic parameter;
  final String endPoint;
  final APIType type;
  final bool isFormData;
  final ResponseType? responseType;
  Map<String, dynamic>? headers;

  APIInput({
    required this.model,
    required this.endPoint,
    required this.type,
    this.parameter,
    this.headers,
    this.responseType,
    this.isFormData = false,
  }) {
    final token = AuthService().getToken();
    headers ??= {};
    headers?["Authorization"] = 'Bearer $token';
  }
}

class APIOutput<T> {
  final T? data;
  final Response<dynamic>? response;
  final DioException? error;

  bool get isNetworkError {
    return error?.error is SocketException;
  }

  String get message {
    return response?.data['message'] ??
        response?.data['error'] ??
        error?.error.toString() ??
        '';
  }

  bool get isSuccess {
    if (response?.data is Uint8List) {
      return response?.statusCode == 200;
    }
    return (response?.data?['status'] == 200) && (response?.statusCode == 200);
  }

  showApiToast({Color backgroundColor = Colors.black}) {
    showToast(
      backgroundColor: backgroundColor,
      message == "null"
          ? "Something went wrong! please try again later"
          : message.toString().contains("SocketException")
              ? "Please check your internet connection!"
              : message.toString().contains("subtype")
                  ? "Something went wrong! please try again later"
                  : message,
    );
  }

  const APIOutput({
    required this.data,
    this.response,
    this.error,
  });
}

abstract class Modelable {
  Modelable fromJson(Map<String, dynamic> json);
}

abstract class Paramable {
  Map<String, dynamic> toJson();
}
