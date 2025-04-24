import 'dart:convert';

TheftDetails theftDetailsFromJson(String str) =>
    TheftDetails.fromJson(json.decode(str));

String theftDetailsToJson(TheftDetails data) =>
    json.encode(data.toJson());

class TheftDetails {
  TheftDetails({
    required this.data,
    required this.message,
    required this.status,
  });

  List<TheftsItem> data;
  String message;
  int status;

  factory TheftDetails.fromJson(Map<dynamic, dynamic> json) =>
      TheftDetails(
        data: List<TheftsItem>.from(
            json["data"].map((x) => TheftsItem.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class TheftsItem {
  TheftsItem({
    required this.theftDetected,
    required this.theftPrevented,
    this.dayOfWeek,
    this.date,
    this.monthName,
  });

  double theftDetected;
  double theftPrevented;
  String? dayOfWeek;
  String? date;
  String? monthName;

  factory TheftsItem.fromJson(Map<dynamic, dynamic> json) =>
      TheftsItem(
        theftDetected: double.parse(json["theft_detected"]),
        theftPrevented: double.parse(json["theft_prevented"]),
        dayOfWeek: json["day_of_week"],
        date: json["date"],
        monthName: json["month_name"],
      );

  Map<dynamic, dynamic> toJson() => {
        "theft_detected": theftDetected,
        "theft_prevented": theftPrevented,
        "day_of_week": dayOfWeek,
        "date": date,
        "month_name": monthName,
      };
}
