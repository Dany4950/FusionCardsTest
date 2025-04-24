import 'dart:convert';

UserData loginDataFromJson(String str) => UserData.fromJson(json.decode(str));

String loginDataToJson(UserData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    required this.metadata,
    required this.userData,
    required this.message,
    required this.status,
  });

  Metadata metadata;
  UserData userData;
  String message;
  int status;

  factory LoginData.fromJson(Map<dynamic, dynamic> json) => LoginData(
        metadata: Metadata.fromJson(json["metadata"]),
        userData: UserData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "data": userData.toJson(),
        "message": message,
        "status": status,
      };

  String get token => userData.token;

  User get user => userData.user;

  DateTime get tokenExpiryDate => userData.tokenExpiryDate;

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiryDate);
}

class UserData {
  UserData({
    required this.tokenExpiryDate,
    required this.user,
    required this.token,
  });

  DateTime tokenExpiryDate;
  User user;
  String token;

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiryDate);

  factory UserData.fromJson(Map<dynamic, dynamic> json) => UserData(
        tokenExpiryDate: DateTime.parse(json["tokenExpiryDate"]),
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<dynamic, dynamic> toJson() => {
        "tokenExpiryDate": tokenExpiryDate.toIso8601String(),
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  User({
    required this.role,
    required this.isMarketplaceUser,
    this.profile, // made nullable
    required this.lastName,
    required this.active,
    required this.createdAt,
    required this.password,
    required this.location,
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.email,
    required this.updatedAt,
  });

  String? role;
  bool? isMarketplaceUser;
  String? profile; // made nullable
  String? lastName;
  bool? active;
  DateTime? createdAt;
  String? password;
  String? location;
  int? id;
  String? mobileNumber;
  String? firstName;
  String? email;
  UpdatedAt? updatedAt;

  bool get isSuperAdmin {
    return role == "superadmin";
  }

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        role: json["role"],
        isMarketplaceUser: json["isMarketplaceUser"],
        profile: json["profile"]?.toString(),
        // handle null case
        lastName: json["last_name"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        password: json["password"],
        location: json["location"],
        id: json["id"],
        mobileNumber: json["mobile_number"],
        firstName: json["first_name"],
        email: json["email"],
        updatedAt: UpdatedAt.fromJson(json["updatedAt"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "role": role,
        "isMarketplaceUser": isMarketplaceUser,
        "profile": profile,
        "last_name": lastName,
        "active": active,
        "createdAt": createdAt?.toIso8601String(),
        "password": password,
        "location": location,
        "id": id,
        "mobile_number": mobileNumber,
        "first_name": firstName,
        "email": email,
        "updatedAt": updatedAt?.toJson(),
      };
}

class UpdatedAt {
  UpdatedAt({
    required this.val,
  });

  String val;

  factory UpdatedAt.fromJson(Map<dynamic, dynamic> json) => UpdatedAt(
        val: json["val"],
      );

  Map<dynamic, dynamic> toJson() => {
        "val": val,
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
