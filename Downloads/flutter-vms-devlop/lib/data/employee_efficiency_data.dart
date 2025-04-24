import 'dart:convert';

EmployeeEfficiencyData employeeEfficiencyDataFromJson(String str) =>
    EmployeeEfficiencyData.fromJson(json.decode(str));

String employeeEfficiencyDataToJson(EmployeeEfficiencyData data) =>
    json.encode(data.toJson());

class EmployeeEfficiencyData {
  EmployeeEfficiencyData({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  List<EmployeeData> data;
  String message;
  int status;

  factory EmployeeEfficiencyData.fromJson(Map<dynamic, dynamic> json) =>
      EmployeeEfficiencyData(
        metadata: Metadata.fromJson(json["metadata"]),
        data: List<EmployeeData>.from(
            json["data"].map((x) => EmployeeData.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class EmployeeData {
  EmployeeData({
    required this.storeId,
    required this.totalIdle,
    required this.efficiencyScore,
    required this.totalCustomer,
    required this.lastName,
    required this.totalMobile,
    required this.totalFillingShelves,
    required this.storeName,
    required this.firstName,
    required this.empId,
  });

  int storeId;
  String? totalIdle;
  int? efficiencyScore;
  String? totalCustomer;
  String? lastName;
  String? totalMobile;
  String? totalFillingShelves;
  String? storeName;
  String? firstName;
  int empId;

  factory EmployeeData.fromJson(Map<dynamic, dynamic> json) => EmployeeData(
        storeId: json["store_id"],
        totalIdle: json["total_idle"],
        efficiencyScore: json["efficiency_score"],
        totalCustomer: json["total_customer"],
        lastName: json["last_name"],
        totalMobile: json["total_mobile"],
        totalFillingShelves: json["total_filling_shelves"],
        storeName: json["store_name"],
        firstName: json["first_name"],
        empId: json["emp_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "store_id": storeId,
        "total_idle": totalIdle,
        "efficiency_score": efficiencyScore,
        "total_customer": totalCustomer,
        "last_name": lastName,
        "total_mobile": totalMobile,
        "total_filling_shelves": totalFillingShelves,
        "store_name": storeName,
        "first_name": firstName,
        "emp_id": empId,
      };
}

class Metadata {
  Metadata({
    required this.port,
    required this.count,
    required this.host,
    required this.latencyMs,
  });

  int port;
  int count;
  String host;
  String latencyMs;

  factory Metadata.fromJson(Map<dynamic, dynamic> json) => Metadata(
        port: json["port"],
        count: json["count"],
        host: json["host"],
        latencyMs: json["latency_ms"],
      );

  Map<dynamic, dynamic> toJson() => {
        "port": port,
        "count": count,
        "host": host,
        "latency_ms": latencyMs,
      };
}
