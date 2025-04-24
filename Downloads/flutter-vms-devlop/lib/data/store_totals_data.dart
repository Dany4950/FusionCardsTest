/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

StoreTotalsData storeTotalsDataFromJson(String str) =>
    StoreTotalsData.fromJson(json.decode(str));

String storeTotalsDataToJson(StoreTotalsData data) =>
    json.encode(data.toJson());

class StoreTotalsData {
  StoreTotalsData({
    required this.data,
    required this.message,
    required this.status,
  });

  StoreTotalsItem data;
  String message;
  int status;

  factory StoreTotalsData.fromJson(Map<dynamic, dynamic> json) =>
      StoreTotalsData(
        data: StoreTotalsItem.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class StoreTotalsItem {
  StoreTotalsItem({
    required this.totaldetectedthefts,
    required this.totalcameracount,
    required this.totalstorecount,
    required this.totalpreventedthefts,
  });

  String totaldetectedthefts;
  String totalcameracount;
  String totalstorecount;
  String totalpreventedthefts;

  factory StoreTotalsItem.fromJson(Map<dynamic, dynamic> json) =>
      StoreTotalsItem(
        totaldetectedthefts: json["totaldetectedthefts"],
        totalcameracount: json["totalcameracount"],
        totalstorecount: json["totalstorecount"],
        totalpreventedthefts: json["totalpreventedthefts"],
      );

  Map<dynamic, dynamic> toJson() => {
        "totaldetectedthefts": totaldetectedthefts,
        "totalcameracount": totalcameracount,
        "totalstorecount": totalstorecount,
        "totalpreventedthefts": totalpreventedthefts,
      };
}
