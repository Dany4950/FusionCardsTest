import 'dart:convert';

import 'package:flutter/material.dart';

EmployeeEfficiencyDetails employeeEfficiencyDetailsFromJson(String str) =>
    EmployeeEfficiencyDetails.fromJson(json.decode(str));

String employeeEfficiencyDetailsToJson(EmployeeEfficiencyDetails data) =>
    json.encode(data.toJson());

class EmployeeEfficiencyDetails {
  EmployeeEfficiencyDetails({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  EmployeeEfficiencyItem data;
  String message;
  int status;

  factory EmployeeEfficiencyDetails.fromJson(Map<dynamic, dynamic> json) =>
      EmployeeEfficiencyDetails(
        metadata: Metadata.fromJson(json["metadata"]),
        data: EmployeeEfficiencyItem.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class EmployeeEfficiencyItem {
  EmployeeEfficiencyItem({
    required this.total,
    required this.data,
    // required this.columns,
  });

  String total;
  List<EmployeeEfficiencyItemData> data;

  // List<Columns>? columns;

  factory EmployeeEfficiencyItem.fromJson(Map<dynamic, dynamic> json) =>
      EmployeeEfficiencyItem(
        total: "${json["total"] ?? 0}",
        data: List<EmployeeEfficiencyItemData>.from(
            json["data"].map((x) => EmployeeEfficiencyItemData.fromJson(x))),
        // columns:
        // List<Columns>.from(json["column"].map((x) => Columns.fromJson(x))),
      );

  get column => null;

  Map<dynamic, dynamic> toJson() => {
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        // "column": List<dynamic>.from(columns?.map((x) => x.toJson())),
      };
}

class Columns {
  Columns({
    required this.header,
    required this.key,
  });

  String header;
  String key;

  factory Columns.fromJson(Map<dynamic, dynamic> json) => Columns(
        header: json["header"],
        key: json["key"],
      );

  Map<dynamic, dynamic> toJson() => {
        "header": header,
        "key": key,
      };
}

class EmployeeEfficiencyItemData {
  EmployeeEfficiencyItemData({
    required this.employeeId,
    required this.storeId,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.storename,
    this.employee,
    this.mobileInSec,
    this.idleInSec,
    this.fillingShelvesInSec,
    this.customerInSec,
    this.mobile,
    this.idle,
    this.fillingShelves,
    this.customer,
    required this.efficiencyScore,
    this.totalCount,
    this.storeLogo,
    required this.photo,
  });

  int employeeId;
  int storeId;
  String firstName;
  String lastName;
  String role;
  int? mobileInSec;
  int? idleInSec;
  int? fillingShelvesInSec;
  int? customerInSec;
  String? mobile;
  String? idle;
  String? fillingShelves;
  String? customer;
  final dynamic efficiencyScore;
  String? totalCount;
  String? storeLogo;
  String? employee;
  String? storename;
  String photo;

  String get fullName {
    return "$firstName $lastName";
  }

  double getEfficiencyScoreAsDecimal() {
    if (efficiencyScore == null) return 0.0;

    try {
      if (efficiencyScore is num) {
        return (efficiencyScore as num).toDouble() / 100;
      }

      String scoreStr = efficiencyScore.toString().replaceAll('%', '').trim();
      return double.tryParse(scoreStr)?.clamp(0, 100) ?? 0.0 / 100;
    } catch (e) {
      debugPrint('Error parsing efficiency score: $e');
      return 0.0;
    }
  }

  String getEfficiencyScoreAsString() {
    if (efficiencyScore == null) return '0%';

    try {
      if (efficiencyScore is num) {
        return '${efficiencyScore.toString()}%';
      }

      String scoreStr = efficiencyScore.toString();
      if (!scoreStr.endsWith('%')) {
        scoreStr = '$scoreStr%';
      }
      return scoreStr;
    } catch (e) {
      debugPrint('Error formatting efficiency score: $e');
      return '0%';
    }
  }

  factory EmployeeEfficiencyItemData.fromJson(Map<String, dynamic> json) {
    return EmployeeEfficiencyItemData(
      employeeId: json['employee_id'] ?? 0,
      employee: json['employee'] ?? 'NA',
      storename: json['store_name'] ?? 'NA',
      storeId: json['store_id'] ?? 0,
      firstName: json['first_name'] ?? 'NA',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      mobileInSec: json['mobile_in_sec'] != null
          ? int.tryParse(json['mobile_in_sec'].toString())
          : 0,
      idleInSec: json['idle_in_sec'] != null
          ? int.tryParse(json['idle_in_sec'].toString())
          : 0,
      fillingShelvesInSec: json['fshelves_in_sec'] != null
          ? int.tryParse(json['fshelves_in_sec'].toString())
          : 0,
      customerInSec: json['customer_in_sec'] != null
          ? int.tryParse(json['customer_in_sec'].toString())
          : 0,
      mobile: json['mobile'] ?? 'null',
      idle: json['idle'] ?? 'null',
      fillingShelves: json['fillingShelves'] ?? 'null',
      customer: json['customer'] ?? 'null',
      efficiencyScore: json['efficiency_score'],
      totalCount: json['total_count'] ?? 'null',
      storeLogo: json['store_logo'] ?? 'null',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'store_id': storeId,
      'first_name': firstName,
      'last_name': lastName,
      'employee': employee,
      'role': role,
      'mobile_in_sec': mobileInSec,
      'idle_in_sec': idleInSec,
      'fshelves_in_sec': fillingShelvesInSec,
      'customer_in_sec': customerInSec,
      'mobile': mobile,
      'idle': idle,
      'fillingShelves': fillingShelves,
      'customer': customer,
      'efficiency_score': efficiencyScore,
      'total_count': totalCount,
      'store_logo': storeLogo,
      'store_name': storename,
      'photo': photo,
    };
  }
}

class Metadata {
  Metadata({
    required this.port,
    required this.host,
    required this.latencyMs,
  });

  int port;
  String host;
  String latencyMs;

  factory Metadata.fromJson(Map<dynamic, dynamic> json) => Metadata(
        port: json["port"],
        host: json["host"],
        latencyMs: json["latency_ms"],
      );

  Map<dynamic, dynamic> toJson() => {
        "port": port,
        "host": host,
        "latency_ms": latencyMs,
      };
}

EmployeeEfficiencySocketData employeeEfficiencySocketDataFromJson(String str) =>
    EmployeeEfficiencySocketData.fromJson(json.decode(str));

String employeeEfficiencySocketDataToJson(EmployeeEfficiencySocketData data) =>
    json.encode(data.toJson());

class EmployeeEfficiencySocketData {
  DateTime? createdAt;
  DateTime? updatedAt;
  int id;
  int? empId;
  dynamic efficiencyType;
  String? videoLink;
  dynamic logIn;
  dynamic logOut;
  int? mobile;
  bool? mobileUsed;
  String? employeeEfficiencyScore;
  dynamic quantity;
  dynamic customer;
  dynamic idle;
  dynamic fillingShelves;
  dynamic foodPurchased;
  dynamic followSafety;
  dynamic presentInStore;
  String photo;

  EmployeeEfficiencySocketData({
    this.createdAt,
    this.updatedAt,
    required this.id,
    this.empId,
    this.efficiencyType,
    this.videoLink,
    this.logIn,
    this.logOut,
    this.mobile,
    this.mobileUsed,
    this.employeeEfficiencyScore,
    this.quantity,
    this.customer,
    this.idle,
    this.fillingShelves,
    this.foodPurchased,
    this.followSafety,
    this.presentInStore,
    required this.photo,
  });

  factory EmployeeEfficiencySocketData.fromJson(Map<String, dynamic> json) =>
      EmployeeEfficiencySocketData(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        id: json["id"],
        empId: json["emp_id"],
        efficiencyType: json["efficiency_type"],
        videoLink: json["videoLink"],
        logIn: json["log_in"],
        logOut: json["log_out"],
        mobile: json["mobile"],
        mobileUsed: json["mobile_used"],
        employeeEfficiencyScore: json["employeeEfficiencyScore"],
        quantity: json["quantity"],
        customer: json["customer"],
        idle: json["idle"],
        fillingShelves: json["fillingShelves"],
        foodPurchased: json["food_purchased"],
        followSafety: json["follow_safety"],
        presentInStore: json["present_in_store"],
        photo: json["photo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "id": id,
        "emp_id": empId,
        "efficiency_type": efficiencyType,
        "videoLink": videoLink,
        "log_in": logIn,
        "log_out": logOut,
        "mobile": mobile,
        "mobile_used": mobileUsed,
        "employeeEfficiencyScore": employeeEfficiencyScore,
        "quantity": quantity,
        "customer": customer,
        "idle": idle,
        "fillingShelves": fillingShelves,
        "food_purchased": foodPurchased,
        "follow_safety": followSafety,
        "present_in_store": presentInStore,
        "photo": photo,
      };
}

extension SocketDataConversion on EmployeeEfficiencySocketData {
  EmployeeEfficiencyItemData toEmployeeEfficiencyItemData() {
    return EmployeeEfficiencyItemData(
      storeId: id,
      efficiencyScore: employeeEfficiencyScore != null
          ? double.tryParse(employeeEfficiencyScore!) ?? 0.0
          : 0.0,
      fillingShelves: fillingShelves,
      role: "Nil",
      // Role data missing on socket
      idle: idle,
      totalCount: null,
      employeeId: empId ?? 0,
      mobile: mobile?.toString(),
      lastName: "Nil",
      firstName: "Nil",
      // FirstName data missing on socket
      customer: customer,
      employee: "Nil",
      photo: photo,
    );
  }
}
