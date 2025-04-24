import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    required this.metadata,
    required this.userData,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  PUserData userData;
  String message;
  int status;

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) => UserDetails(
        metadata: Metadata.fromJson(json["metadata"]),
        userData: PUserData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "data": userData.toJson(),
        "message": message,
        "status": status,
      };
}

class PUserData {
  PUserData({
    required this.role,
    required this.isMarketplaceUser,
    required this.lastName,
    required this.active,
    required this.createdAt,
    required this.location,
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.email,
    required this.updatedAt,
  });

  String? role;
  bool? isMarketplaceUser;
  String? lastName;
  bool? active;
  DateTime? createdAt;
  String? location;
  int? id;
  String? mobileNumber;
  String? firstName;
  String? email;
  DateTime? updatedAt;

  factory PUserData.fromJson(Map<dynamic, dynamic> json) => PUserData(
        role: json["role"],
        isMarketplaceUser: json["isMarketplaceUser"],
        lastName: json["last_name"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        location: json["location"],
        id: json["id"],
        mobileNumber: json["mobile_number"],
        firstName: json["first_name"],
        email: json["email"],
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "role": role,
        "isMarketplaceUser": isMarketplaceUser,
        "last_name": lastName,
        "active": active,
        "createdAt": createdAt?.toIso8601String(),
        "location": location,
        "id": id,
        "mobile_number": mobileNumber,
        "first_name": firstName,
        "email": email,
        "updatedAt": updatedAt?.toIso8601String(),
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
