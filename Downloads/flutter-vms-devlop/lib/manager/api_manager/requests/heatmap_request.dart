import 'dart:convert';

import 'package:vms/manager/api_manager/api_controller.dart';
import 'package:vms/manager/api_manager/url.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

abstract class HeatmapRequest {
  static Future<APIInput<AisleCountData>> fetchAisleData(
      String storeId, int page, DateRangeType range) async {
    String dateType;
    switch (range) {
      case DateRangeType.oneHour:
        dateType = "1hr";
        break;
      case DateRangeType.threeHours:
        dateType = "3hr";
        break;
      case DateRangeType.fiveHours:
        dateType = "5hr";
        break;
      case DateRangeType.sevenHours:
        dateType = "7hr";
        break;
      case DateRangeType.oneDay:
        dateType = "1";
        break;
      case DateRangeType.threeDays:
        dateType = "3";
        break;
      case DateRangeType.lastWeek:
        dateType = "7";
        break;
      case DateRangeType.sevenDays:
        dateType = "7";
        break;
      default:
        dateType = "7";
    }
    return APIInput(
      model: (json) => AisleCountData.fromJson(json),
      endPoint: "${EndPoint.getAisleData}/$storeId",
      type: APIType.getQuery,
      headers: {"Datetype": dateType},
    );
  }

  static Future<APIInput<String>> fetchHeatmapFloorImage(
      String storeId, int page, DateRangeType range) async {
    String dateType;
    switch (range) {
      case DateRangeType.oneHour:
        dateType = "1hr";
        break;
      case DateRangeType.threeHours:
        dateType = "3hr";
        break;
      case DateRangeType.fiveHours:
        dateType = "5hr";
        break;
      case DateRangeType.sevenHours:
        dateType = "7hr";
        break;
      case DateRangeType.oneDay:
        dateType = "1";
        break;
      case DateRangeType.threeDays:
        dateType = "3";
        break;
      case DateRangeType.lastWeek:
        dateType = "7";
        break;
      case DateRangeType.sevenDays:
        dateType = "7";
        break;
      default:
        dateType = "7";
    }
    return APIInput(
      model: (dynamic data) {
        if (data is Map<String, dynamic>) {
          return data['data'] as String? ?? '';
        }
        return '';
      },
      endPoint: "${EndPoint.getHeatMapFloorImage}/$dateType/$storeId",
      type: APIType.getQuery,
    );
  }

  static Future<APIInput<String>> fetchHeatmapImagesbyCamera(
      String storeId, int page, DateRangeType range) async {
    String dateType;
    switch (range) {
      case DateRangeType.oneHour:
        dateType = "1hr";
        break;
      case DateRangeType.threeHours:
        dateType = "3hr";
        break;
      case DateRangeType.fiveHours:
        dateType = "5hr";
        break;
      case DateRangeType.sevenHours:
        dateType = "7hr";
        break;
      case DateRangeType.oneDay:
        dateType = "1";
        break;
      case DateRangeType.threeDays:
        dateType = "3";
        break;
      case DateRangeType.lastWeek:
        dateType = "7";
        break;
      case DateRangeType.sevenDays:
        dateType = "7";
        break;
      default:
        dateType = "7";
    }
    return APIInput(
      model: (dynamic data) {
        if (data is Map<String, dynamic> &&
            data.containsKey('data')) {
          return jsonEncode(data['data']);
        }
        return '';
      },
      endPoint:
          "${EndPoint.getHeatMapImagesbyCamera}/$dateType/$storeId/$page/30",
      type: APIType.getQuery,
    );
  }

  static Future<APIInput<dynamic>> fetchLiveHeatmapData(
      String storeId) async {
    return APIInput(
      model: (json) => json,
      endPoint: "${EndPoint.getAisleData}/$storeId",
      type: APIType.getQuery,
      headers: {"Datetype": "live"},
    );
  }
}

class AisleCountData {
  final String message;
  final int status;
  final List<StoreAisleData> data;
  final Metadata metadata;

  AisleCountData({
    required this.message,
    required this.status,
    required this.data,
    required this.metadata,
  });

  factory AisleCountData.fromJson(Map<String, dynamic> json) {
    return AisleCountData(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
      data: (json["data"] as List<dynamic>? ?? [])
          .map((item) => StoreAisleData.fromJson(item))
          .toList(),
      metadata: Metadata.fromJson(json["metadata"] ?? {}),
    );
  }
}

class StoreAisleData {
  final String storeId;
  final String storeName;
  final String? storeLogo;
  final Map<String, AisleDetails> aisleDetails;
  final String totalPeopleCount;

  StoreAisleData({
    required this.storeId,
    required this.storeName,
    this.storeLogo,
    required this.aisleDetails,
    required this.totalPeopleCount,
  });

  factory StoreAisleData.fromJson(Map<String, dynamic> json) {
    return StoreAisleData(
      storeId: json["store_id"]?.toString() ?? "",
      storeName: json["store_name"] ?? "",
      storeLogo: json["store_logo"],
      aisleDetails:
          (json["aisle_details"] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(
                  key,
                  AisleDetails.fromJson(value is Map
                      ? Map<String, dynamic>.from(value)
                      : {}),
                ),
              ) ??
              {},
      totalPeopleCount: json["total_people_count"]?.toString() ?? "0",
    );
  }
}

class AisleDetails {
  final int count;
  final String timespent;
  final double percentage;

  AisleDetails({
    required this.count,
    required this.timespent,
    required this.percentage,
  });

  factory AisleDetails.fromJson(Map<String, dynamic> json) {
    return AisleDetails(
      count: json["count"] is int
          ? json["count"]
          : int.tryParse(json["count"]?.toString() ?? '0') ?? 0,
      timespent: json["timespent"]?.toString() ?? "00:00:00",
      percentage: json["percentage"] is num
          ? (json["percentage"] as num).toDouble()
          : double.tryParse(
                  json["percentage"]?.toString() ?? '0.0') ??
              0.0,
    );
  }
}

class Metadata {
  final int count;
  final String host;
  final int port;
  final String latencyMs;

  Metadata({
    required this.count,
    required this.host,
    required this.port,
    required this.latencyMs,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      count: json["count"] ?? 0,
      host: json["host"] ?? "",
      port: json["port"] ?? 0,
      latencyMs: json["latency_ms"]?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'host': host,
        'port': port,
        'latency_ms': latencyMs,
      };
}
