/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

PeopleCountHistoryData peopleCountHistoryDataFromJson(String str) =>
    PeopleCountHistoryData.fromJson(json.decode(str));

String peopleCountHistoryDataToJson(PeopleCountHistoryData data) =>
    json.encode(data.toJson());

class PeopleCountHistoryData {
  PeopleCountHistoryData({
    required this.metadata,
    required this.data,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  PeopleCountHistoryItem data;
  String message;
  int status;

  factory PeopleCountHistoryData.fromJson(Map<dynamic, dynamic> json) =>
      PeopleCountHistoryData(
        metadata: Metadata.fromJson(json["metadata"]),
        data: PeopleCountHistoryItem.fromJson(json["data"]),
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

class PeopleCountHistoryItem {
  PeopleCountHistoryItem({
    required this.total,
    required this.peopleCountDataPerStore,
    required this.column,
  });

  // Change type from String to dynamic to handle potential null values
  dynamic total;
  List<PeopleCountDataPerStore> peopleCountDataPerStore;
  List<Columns> column;

  factory PeopleCountHistoryItem.fromJson(Map<dynamic, dynamic> json) =>
      PeopleCountHistoryItem(
        total: json["total"] ?? "0", // Provide default value if null
        peopleCountDataPerStore: List<PeopleCountDataPerStore>.from(
            (json["data"] ?? [])
                .map((x) => PeopleCountDataPerStore.fromJson(x))),
        column: List<Columns>.from(
            (json["column"] ?? []).map((x) => Columns.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "total": total,
        "data":
            List<dynamic>.from(peopleCountDataPerStore.map((x) => x.toJson())),
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

class PeopleCountDataPerStore {
  PeopleCountDataPerStore({
    required this.storeId,
    required this.predictedmean,
    required this.noofcustomers,
    required this.hour,
    required this.totalCount,
    required this.predictedPercentage,
    required this.store,
    required this.goingOutCount,
    required this.busyhour,
    required this.date,
    required this.month,
  });

  int storeId;
  int predictedmean;
  String noofcustomers;
  String hour;
  String totalCount;
  int predictedPercentage;
  String store;
  String goingOutCount;
  String busyhour;
  String date;
  String month;

  factory PeopleCountDataPerStore.fromJson(Map<dynamic, dynamic> json) {
    return PeopleCountDataPerStore(
      storeId: int.tryParse(json["store_id"]?.toString() ?? "0") ?? 0,
      predictedmean:
          int.tryParse(json["predictedmean"]?.toString() ?? "0") ?? 0,
      noofcustomers: json["noofcustomers"]?.toString() ?? "0",
      hour: json["hour"]?.toString() ?? "",
      totalCount: json["total_count"]?.toString() ?? "0",
      predictedPercentage:
          int.tryParse(json["predicted_percentage"]?.toString() ?? "0") ?? 0,
      store: json["store"]?.toString() ?? "Unknown Store",
      goingOutCount: json["going_out_count"]?.toString() ?? "0",
      busyhour: json["busyhour"]?.toString() ?? "N/A",
      date: json["date"] ?? "N/A",
      month: json["month_name"] ?? "N/A",
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "store_id": storeId,
        "predictedmean": predictedmean,
        "noofcustomers": noofcustomers,
        "hour": hour,
        "total_count": totalCount,
        "predicted_percentage": predictedPercentage,
        "store": store,
        "going_out_count": goingOutCount,
        "busyhour": busyhour,
        "date": date,
        "month_name": month,
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

class BusyHourProjection {
  final String localDateTime;
  final String timeRange;
  final String start;
  final String end;
  final int predictedMean;
  final bool isBusyHour;

  BusyHourProjection({
    required this.localDateTime,
    required this.timeRange,
    required this.start,
    required this.end,
    required this.predictedMean,
    required this.isBusyHour,
  });

  factory BusyHourProjection.fromJson(Map<String, dynamic> json) {
    return BusyHourProjection(
      localDateTime: json['local_datetime'] ?? '',
      timeRange: json['time_range'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      predictedMean: json['predictedMean'] ?? 0,
      isBusyHour: json['isBusyHour'] ?? false,
    );
  }
}

class WeeklyForecast {
  final String date;
  final int predictedMean;
  final String dayName;
  final bool isBusyDay;

  WeeklyForecast({
    required this.date,
    required this.predictedMean,
    required this.dayName,
    required this.isBusyDay,
  });

  factory WeeklyForecast.fromJson(Map<String, dynamic> json) {
    return WeeklyForecast(
      date: json['date'] ?? '',
      predictedMean: json['predictedMean'] ?? 0,
      dayName: json['day_name'] ?? '',
      isBusyDay: json['isBusyDay'] ?? false,
    );
  }
}

class WeeklyForecastResponse {
  final String message;
  final int status;
  final List<WeeklyForecast> data;
  final Map<String, dynamic> metadata;

  WeeklyForecastResponse({
    required this.message,
    required this.status,
    required this.data,
    required this.metadata,
  });

  factory WeeklyForecastResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<WeeklyForecast> dataList =
        list.map((i) => WeeklyForecast.fromJson(i)).toList();

    return WeeklyForecastResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: dataList,
      metadata: json['metadata'] ?? {},
    );
  }
}

class ForecastData {
  final String? time;
  final String? date;
  final String? dayName;
  final int predictedMean;
  final bool isBusy;

  ForecastData({
    this.time,
    this.date,
    this.dayName,
    required this.predictedMean,
    required this.isBusy,
  });

  factory ForecastData.fromBusyHourProjection(BusyHourProjection data) {
    return ForecastData(
      time: data.end,
      predictedMean: data.predictedMean,
      isBusy: data.isBusyHour,
    );
  }

  factory ForecastData.fromWeeklyForecast(WeeklyForecast data) {
    return ForecastData(
      date: data.date,
      dayName: data.dayName,
      predictedMean: data.predictedMean,
      isBusy: data.isBusyDay,
    );
  }

  String get xAxisLabel {
    return time ??
        (date != null
            ? '${dayName!.substring(0, 3)}\n${date!.substring(8, 10)}'
            : '');
  }
}
