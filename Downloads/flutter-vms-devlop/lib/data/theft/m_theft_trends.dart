// To parse this JSON data, do
//
//     final mTheftTrends = mTheftTrendsFromJson(jsonString);

import 'dart:convert';

MTheftTrends mTheftTrendsFromJson(String str) =>
    MTheftTrends.fromJson(json.decode(str));

String mTheftTrendsToJson(MTheftTrends data) => json.encode(data.toJson());

class MTheftTrends {
  String? dayOfWeek;
  String? timeInterval;
  String? theftCount;

  MTheftTrends({
    this.dayOfWeek,
    this.timeInterval,
    this.theftCount,
  });

  factory MTheftTrends.fromJson(Map<String, dynamic> json) => MTheftTrends(
        dayOfWeek: json["day_of_week"],
        timeInterval: json["time_interval"],
        theftCount: json["theft_count"],
      );

  Map<String, dynamic> toJson() => {
        "day_of_week": dayOfWeek,
        "time_interval": timeInterval,
        "theft_count": theftCount,
      };
}
