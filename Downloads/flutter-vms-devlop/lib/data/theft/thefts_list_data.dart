/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

TheftsListData theftsListDataFromJson(String str) =>
    TheftsListData.fromJson(json.decode(str));

String theftsListDataToJson(TheftsListData data) => json.encode(data.toJson());

class TheftsListData {
  TheftsListData({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  TheftsListItemData data;
  String message;
  int status;

  factory TheftsListData.fromJson(Map<dynamic, dynamic> json) => TheftsListData(
        metadata: Metadata.fromJson(json["metadata"]),
        data: TheftsListItemData.fromJson(json["data"]),
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

class TheftsListItemData {
  TheftsListItemData({
    required this.total,
    required this.data,
    required this.column,
  });

  String total;
  List<TheftsListItem> data;
  List<Columns> column;

  factory TheftsListItemData.fromJson(Map<dynamic, dynamic> json) =>
      TheftsListItemData(
        total: "${json["total"] ?? 0}",
        data: List<TheftsListItem>.from(
            json["data"].map((x) => TheftsListItem.fromJson(x))),
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

class TheftsListItem {
  TheftsListItem({
    required this.videoUri,
    required this.storeId,
    required this.validatedBy,
    required this.dateValidated,
    required this.createdAt,
    required this.totalCount,
    required this.profile,
    required this.name,
    required this.lastName,
    required this.theftProbability,
    required this.firstName,
  });

  String? videoUri;
  int storeId;
  int? validatedBy;
  DateTime dateValidated;
  DateTime createdAt;
  String? totalCount;
  String? profile;
  String? name;
  LastName? lastName;
  String theftProbability;
  FirstName? firstName;

  factory TheftsListItem.fromJson(Map<dynamic, dynamic> json) => TheftsListItem(
        videoUri: json["video_uri"],
        storeId: json["store_id"],
        validatedBy: json["validated_by"],
        dateValidated: DateTime.parse(json["date_validated"]),
        createdAt: DateTime.parse(json["createdAt"]),
        totalCount: json["total_count"],
        profile: json["profile"],
        name: json["name"] ?? json["itemName"],
        lastName: lastNameValues.map[json["last_name"]],
        theftProbability: json["theftProbability"].toString(),
        firstName: firstNameValues.map[json["first_name"]],
      );

  Map<dynamic, dynamic> toJson() => {
        "video_uri": videoUri,
        "store_id": storeId,
        "validated_by": validatedBy,
        "date_validated": dateValidated.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "total_count": totalCount,
        "profile": profile,
        "name": name,
        "last_name": lastNameValues.reverse[lastName],
        "theftProbability": theftProbability,
        "first_name": firstNameValues.reverse[firstName],
      };
}

enum FirstName { ANUSHIYA }

final firstNameValues = EnumValues({"anushiya": FirstName.ANUSHIYA});

enum LastName { P }

final lastNameValues = EnumValues({"p": LastName.P});

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
