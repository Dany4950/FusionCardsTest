import 'dart:convert';

AllStoresData allStoresFromJson(String str) =>
    AllStoresData.fromJson(json.decode(str));

String allStoresToJson(AllStoresData data) => json.encode(data.toJson());

class AllStoresData {
  AllStoresData({
    required this.data,
    required this.message,
    required this.status,
  });

  StoresDDItem data;
  String message;
  int status;

  factory AllStoresData.fromJson(Map<dynamic, dynamic> json) => AllStoresData(
        data: StoresDDItem.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class StoresDDItem {
  StoresDDItem({
    required this.storeData,
  });

  List<StoreData> storeData;

  factory StoresDDItem.fromJson(Map<dynamic, dynamic> json) => StoresDDItem(
        storeData: List<StoreData>.from(
            json["data"].map((x) => StoreData.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(storeData.map((x) => x.toJson())),
      };
}

class StoreData {
  StoreData({
    required this.name,
    required this.id,
    this.hasKitchen,
  });

  String name;
  int id;
  bool? hasKitchen;

  factory StoreData.fromJson(Map<dynamic, dynamic> json) => StoreData(
        name: json["name"],
        id: json["id"],
        hasKitchen: json["hasKitchen"],
      );

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "id": id,
        "hasKitchen": hasKitchen,
      };
}
