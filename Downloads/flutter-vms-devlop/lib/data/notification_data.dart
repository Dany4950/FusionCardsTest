
class NotificationData {
  NotificationData({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  int status;
  List<NotificationModel> data;

  factory NotificationData.fromJson(Map<dynamic, dynamic> json) => NotificationData(
        message: json["message"],
        status: json["status"],
        data: List<NotificationModel>.from(json["data"].map((x) => NotificationModel.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}



class NotificationModel {
  NotificationModel({
    required this.id,
    this.theftId,
    required this.message,
    required this.createdAt,
    this.theftProbability,
    this.storeName,
    this.storeId,
    this.videoUri,
  });

  int id;
  int? theftId;
  String message;
  String createdAt;
  String? theftProbability;
  String? storeName;
  int? storeId;
  String? videoUri;

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) =>
      NotificationModel(
        id: json["id"] ?? 0,
        theftId: json["theft_id"],
        message: json["message"] ?? "",
        createdAt: json["createdAt"] ?? "",
        theftProbability: json["theftProbability"],
        storeName: json["store_name"],
        storeId: json["store_id"],
        videoUri: json["video_uri"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "theft_id": theftId,
        "message": message,
        "createdAt": createdAt,
        "theftProbability": theftProbability,
        "store_name": storeName,
        "store_id": storeId,
        "video_uri": videoUri,
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