
import 'dart:convert';

AllStoreDetails allStoreDetailsFromJson(String str) => AllStoreDetails.fromJson(json.decode(str));

String allStoreDetailsToJson(AllStoreDetails data) => json.encode(data.toJson());

class AllStoreDetails {
    AllStoreDetails({
        required this.data,
        required this.message,
        required this.status,
    });

    Data data;
    String message;
    int status;

    factory AllStoreDetails.fromJson(Map<dynamic, dynamic> json) => AllStoreDetails(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
    };
}

class Data {
    Data({
        required this.total,
        required this.data,
    });

    String total;
    List<Datum> data;

    factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        total: json["total"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<dynamic, dynamic> toJson() => {
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.pincode,
        required this.country,
        required this.address,
        required this.manager,
        this.floormap,
        required this.timezone,
        required this.totalCount,
        required this.openingTime,
        required this.active,
        required this.theftPreventedCount,
        required this.createdBy,
        required this.cameraCount,
        required this.createdAt,
        required this.isPaid,
        required this.kitchenFeatures,
        required this.hasKitchen,
        required this.name,
        required this.id,
        required this.is24HrStore,
        required this.theftDetectedCount,
        required this.updatedAt,
        this.logo,
        this.closingTime,
    });

    String pincode;
    String country;
    String address;
    String manager;
    String? floormap;
    Timezone timezone;
    String totalCount;
    String openingTime;
    bool active;
    String theftPreventedCount;
    int createdBy;
    String cameraCount;
    DateTime createdAt;
    bool isPaid;
    KitchenFeatures kitchenFeatures;
    bool hasKitchen;
    String name;
    int id;
    bool is24HrStore;
    String theftDetectedCount;
    DateTime updatedAt;
    String? logo;
    String? closingTime;

    factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
        pincode: json["pincode"],
        country: json["country"],
        address: json["address"],
        manager: json["manager"],
        floormap: json["floormap"],
        timezone: timezoneValues.map[json["timezone"]]!,
        totalCount: json["total_count"],
        openingTime: json["openingTime"],
        active: json["active"],
        theftPreventedCount: json["theft_prevented_count"],
        createdBy: json["created_by"],
        cameraCount: json["camera_count"],
        createdAt: DateTime.parse(json["createdAt"]),
        isPaid: json["isPaid"],
        kitchenFeatures: KitchenFeatures.fromJson(json["kitchenFeatures"]),
        hasKitchen: json["hasKitchen"],
        name: json["name"],
        id: json["id"],
        is24HrStore: json["is24HrStore"],
        theftDetectedCount: json["theft_detected_count"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        logo: json["logo"],
        closingTime: json["closingTime"],
    );

    Map<dynamic, dynamic> toJson() => {
        "pincode": pincode,
        "country": country,
        "address": address,
        "manager": manager,
        "floormap": floormap,
        "timezone": timezoneValues.reverse[timezone],
        "total_count": totalCount,
        "openingTime": openingTime,
        "active": active,
        "theft_prevented_count": theftPreventedCount,
        "created_by": createdBy,
        "camera_count": cameraCount,
        "createdAt": createdAt.toIso8601String(),
        "isPaid": isPaid,
        "kitchenFeatures": kitchenFeatures.toJson(),
        "hasKitchen": hasKitchen,
        "name": name,
        "id": id,
        "is24HrStore": is24HrStore,
        "theft_detected_count": theftDetectedCount,
        "updatedAt": updatedAt.toIso8601String(),
        "logo": logo,
        "closingTime": closingTime,
    };
}

class KitchenFeatures {
    KitchenFeatures({
        required this.hairnetViolation,
        required this.glovesViolation,
        required this.uniformViolation,
        required this.apronViolation,
        required this.maskViolation,
    });

    bool hairnetViolation;
    bool glovesViolation;
    bool uniformViolation;
    bool apronViolation;
    bool maskViolation;

    factory KitchenFeatures.fromJson(Map<dynamic, dynamic> json) => KitchenFeatures(
        hairnetViolation: json["hairnet_violation"],
        glovesViolation: json["gloves_violation"],
        uniformViolation: json["uniform_violation"],
        apronViolation: json["apron_violation"],
        maskViolation: json["mask_violation"],
    );

    Map<dynamic, dynamic> toJson() => {
        "hairnet_violation": hairnetViolation,
        "gloves_violation": glovesViolation,
        "uniform_violation": uniformViolation,
        "apron_violation": apronViolation,
        "mask_violation": maskViolation,
    };
}

enum Timezone { AMERICA_NEW_YORK, UTC }

final timezoneValues = EnumValues({
    "America/New_York": Timezone.AMERICA_NEW_YORK,
    "UTC": Timezone.UTC
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
