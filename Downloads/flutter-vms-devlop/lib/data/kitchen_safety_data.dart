import 'dart:convert';

KitchenSafetyData employeeSafetyDataFromJson(String str) =>
    KitchenSafetyData.fromJson(json.decode(str));

String employeeSafetyDataToJson(KitchenSafetyData data) =>
    json.encode(data.toJson());

class KitchenSafetyData {
  KitchenSafetyData({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  KitchenSafetyMain data;
  String message;
  int status;

  factory KitchenSafetyData.fromJson(Map<dynamic, dynamic> json) =>
      KitchenSafetyData(
        metadata: Metadata.fromJson(json["metadata"]),
        data: KitchenSafetyMain.fromJson(json["data"]),
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

class KitchenSafetyMain {
  KitchenSafetyMain({
    required this.total,
    required this.data,
    required this.column,
  });

  String total;
  List<KsEmployeeData> data;
  List<Columns> column;

  factory KitchenSafetyMain.fromJson(Map<dynamic, dynamic> json) =>
      KitchenSafetyMain(
        total: "${json["total"] ?? 0}",
        data: List<KsEmployeeData>.from(
            json["data"].map((x) => KsEmployeeData.fromJson(x))),
        column:
            List<Columns>.from(json["column"].map((x) => Columns.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "column": List<dynamic>.from(column.map((x) => x.toJson())),
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

class KsEmployeeData {
  KsEmployeeData({
    required this.storeId,
    required this.createdAt,
    required this.wearingUniform,
    required this.imgLink,
    required this.totalCount,
    required this.employeeId,
    required this.wearingHairNet,
    required this.lastName,
    required this.wearingGloves,
    required this.firstName,
    required this.wearingMask,
    this.photo = '',
  });

  int storeId;
  DateTime createdAt;
  String wearingUniform;
  String imgLink;
  String totalCount;
  int employeeId;
  String wearingHairNet;
  String lastName;
  String wearingGloves;
  String firstName;
  String wearingMask;
  String photo;

  String get fullName {
    return "$firstName $lastName";
  }

  factory KsEmployeeData.fromJson(Map<dynamic, dynamic> json) => KsEmployeeData(
        storeId: json["store_id"] ?? json["id"] ?? 0,
        createdAt:
            DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
        wearingUniform: json["wearing_uniform"] ?? "false",
        imgLink: json["img_link"] ?? 'NA',
        totalCount: json["total_count"] ?? "0",
        employeeId: json["employee_id"] ?? 'NA',
        wearingHairNet: json["wearing_hair_net"] ?? "false",
        lastName: json["last_name"],
        wearingGloves: json["wearing_gloves"] ?? "fasle",
        firstName: json["first_name"],
        wearingMask: json["wearing_mask"] ?? "false",
        photo: json["photo"] ?? '',
      );

  Map<dynamic, dynamic> toJson() => {
        "store_id": storeId,
        "createdAt": createdAt.toIso8601String(),
        "wearing_uniform": wearingUniform,
        "img_link": imgLink,
        "total_count": totalCount,
        "employee_id": employeeId,
        "wearing_hair_net": wearingHairNet,
        "last_name": lastName,
        "wearing_gloves": wearingGloves,
        "first_name": firstName,
        "wearing_mask": wearingMask,
        "photo": photo,
      };
}

// enum Wearing { NOT_APPLICABLE }

// final wearingValues = EnumValues({"Not Applicable": Wearing.NOT_APPLICABLE});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
