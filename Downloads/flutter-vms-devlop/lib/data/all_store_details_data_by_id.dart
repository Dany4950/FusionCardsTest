// To parse this JSON data, do
//
//     final allStoreDetailsDataById = allStoreDetailsDataByIdFromJson(jsonString);

import 'dart:convert';

AllStoreDetailsDataById allStoreDetailsDataByIdFromJson(String str) =>
    AllStoreDetailsDataById.fromJson(json.decode(str));

String allStoreDetailsDataByIdToJson(AllStoreDetailsDataById data) =>
    json.encode(data.toJson());

class AllStoreDetailsDataById {
  String? message;
  int? status;
  List<AllStoreDetailsItem>? data;
  Metadata? metadata;

  AllStoreDetailsDataById({
    this.message,
    this.status,
    this.data,
    this.metadata,
  });

  factory AllStoreDetailsDataById.fromJson(Map<String, dynamic> json) =>
      AllStoreDetailsDataById(
        message: json["message"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<AllStoreDetailsItem>.from(
                json["data"]!.map((x) => AllStoreDetailsItem.fromJson(x))),
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "metadata": metadata?.toJson(),
      };
}

class AllStoreDetailsItem {
  int? storeId;
  String? name;
  String? manager;
  String? address;
  String? pincode;
  String? country;
  dynamic logo;
  bool? hasKitchen;
  dynamic mobileNumber;
  bool? is24HrStore;
  String? timezone;
  int? count;
  String? busyHours;
  String? aisleName;
  String? cameraCount;
  String? theftDetectedCount;
  String? theftPreventedCount;

  AllStoreDetailsItem({
    this.storeId,
    this.name,
    this.manager,
    this.address,
    this.pincode,
    this.country,
    this.logo,
    this.hasKitchen,
    this.mobileNumber,
    this.is24HrStore,
    this.timezone,
    this.count,
    this.busyHours,
    this.aisleName,
    this.cameraCount,
    this.theftDetectedCount,
    this.theftPreventedCount,
  });

  factory AllStoreDetailsItem.fromJson(Map<String, dynamic> json) =>
      AllStoreDetailsItem(
        storeId: json["store_id"],
        name: json["name"],
        manager: json["manager"],
        address: json["address"],
        pincode: json["pincode"],
        country: json["country"],
        logo: json["logo"],
        hasKitchen: json["hasKitchen"],
        mobileNumber: json["mobileNumber"],
        is24HrStore: json["is24HrStore"],
        timezone: json["timezone"],
        count: json["count"],
        busyHours: json["busy_hours"],
        aisleName: json["aisle_name"],
        cameraCount: json["camera_count"],
        theftDetectedCount: json["theft_detected_count"],
        theftPreventedCount: json["theft_prevented_count"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "name": name,
        "manager": manager,
        "address": address,
        "pincode": pincode,
        "country": country,
        "logo": logo,
        "hasKitchen": hasKitchen,
        "mobileNumber": mobileNumber,
        "is24HrStore": is24HrStore,
        "timezone": timezone,
        "count": count,
        "busy_hours": busyHours,
        "aisle_name": aisleName,
        "camera_count": cameraCount,
        "theft_detected_count": theftDetectedCount,
        "theft_prevented_count": theftPreventedCount,
      };
}

class Metadata {
  int? count;
  String? host;
  int? port;
  String? latencyMs;

  Metadata({
    this.count,
    this.host,
    this.port,
    this.latencyMs,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        count: json["count"],
        host: json["host"],
        port: json["port"],
        latencyMs: json["latency_ms"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "host": host,
        "port": port,
        "latency_ms": latencyMs,
      };
}
