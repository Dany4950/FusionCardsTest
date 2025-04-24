import 'dart:convert';

PeopleCountLiveResponse peopleCountLiveResponseFromJson(String str) =>
    PeopleCountLiveResponse.fromJson(json.decode(str));

String peopleCountLiveResponseToJson(PeopleCountLiveResponse data) =>
    json.encode(data.toJson());

class PeopleCountLiveResponse {
  PeopleCountLiveResponse({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  StorePeopleCountData data;
  String message;
  int status;

  factory PeopleCountLiveResponse.fromJson(Map<dynamic, dynamic> json) =>
      PeopleCountLiveResponse(
        metadata: Metadata.fromJson(json["metadata"]),
        data: StorePeopleCountData.fromJson(json["data"]),
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

class StorePeopleCountData {
  StorePeopleCountData({
    required this.total,
    required this.storePeopleCountItems,
    required this.column,
  });

  int total;
  List<StorePeopleCountItem> storePeopleCountItems;
  List<Columns> column;

  factory StorePeopleCountData.fromJson(Map<dynamic, dynamic> json) =>
      StorePeopleCountData(
        total: json["total"],
        storePeopleCountItems: List<StorePeopleCountItem>.from(
            json["data"].map((x) => StorePeopleCountItem.fromJson(x))),
        column:
            List<Columns>.from(json["column"].map((x) => Columns.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "total": total,
        "data":
            List<dynamic>.from(storePeopleCountItems.map((x) => x.toJson())),
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

class StorePeopleCountItem {
  StorePeopleCountItem({
    required this.storeId,
    required this.cameraId,
    required this.store,
    required this.goingOutCount,
    required this.goingOut,
    required this.createdAt,
    required this.noofcustomers,
    required this.currenthrgoingout,
    required this.currenthrgoingin,
    required this.noofcustomersgoingout,
    required this.id,
    required this.currentBusyhour,
    required this.goingIn,
    required this.busyhour,
    required this.updatedAt,
    this.predictedmean,
    this.predictedPercentage,
  });

  int storeId;
  int? cameraId;
  String? store;
  int? goingOutCount;
  int? goingOut;
  DateTime createdAt;
  int? noofcustomers;
  int? currenthrgoingout;
  int? currenthrgoingin;
  int? noofcustomersgoingout;
  int? id;
  String? currentBusyhour;
  int? goingIn;
  String? busyhour;
  DateTime updatedAt;
  int? predictedmean;
  int? predictedPercentage;

  factory StorePeopleCountItem.fromJson(Map<dynamic, dynamic> json) =>
      StorePeopleCountItem(
        storeId: json["store_id"],
        cameraId: json["camera_id"],
        store: json["store"],
        goingOutCount: json["going_out_count"],
        goingOut: json["going_out"],
        createdAt: DateTime.parse(json["createdAt"]),
        noofcustomers: json["noofcustomers"],
        currenthrgoingout: json["currenthrgoingout"],
        currenthrgoingin: json["currenthrgoingin"],
        noofcustomersgoingout: json["noofcustomersgoingout"],
        id: json["id"],
        currentBusyhour: json["current_busyhour"],
        goingIn: json["going_in"],
        busyhour: json["busyhour"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        predictedmean: json["predictedmean"],
        predictedPercentage: json["predicted_percentage"],
      );

  Map<dynamic, dynamic> toJson() => {
        "store_id": storeId,
        "camera_id": cameraId,
        "store": store,
        "going_out_count": goingOutCount,
        "going_out": goingOut,
        "createdAt": createdAt.toIso8601String(),
        "noofcustomers": noofcustomers,
        "currenthrgoingout": currenthrgoingout,
        "currenthrgoingin": currenthrgoingin,
        "noofcustomersgoingout": noofcustomersgoingout,
        "id": id,
        "current_busyhour": currentBusyhour,
        "going_in": goingIn,
        "busyhour": busyhour,
        "updatedAt": updatedAt.toIso8601String(),
        "predictedmean": predictedmean,
        "predicted_percentage": predictedPercentage,
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
