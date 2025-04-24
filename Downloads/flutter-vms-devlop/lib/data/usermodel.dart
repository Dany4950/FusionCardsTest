// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
    String? message;
    int? status;
    Data? data;
    Metadata? metadata;

    Usermodel({
        this.message,
        this.status,
        this.data,
        this.metadata,
    });

    factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        message: json["message"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data?.toJson(),
        "metadata": metadata?.toJson(),
    };
}

class Data {
    // String? token;
    // DateTime? tokenExpiryDate;
    User? user;

    Data({
        // this.token,
        // this.tokenExpiryDate,
        this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        // token: json["token"],
        // tokenExpiryDate: json["tokenExpiryDate"] == null ? null : DateTime.parse(json["tokenExpiryDate"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        // "token": token,
        // "tokenExpiryDate": tokenExpiryDate?.toIso8601String(),
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? firstName;
    String? lastName;
    String? email;
    String? password;
    dynamic mobileNumber;
    String? role;
    dynamic profile;
    String? lensId;
    bool? active;
    bool? isMarketplaceUser;
    dynamic location;
    DateTime? createdAt;
    UpdatedAt? updatedAt;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.password,
        this.mobileNumber,
        this.role,
        this.profile,
        this.lensId,
        this.active,
        this.isMarketplaceUser,
        this.location,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobile_number"],
        role: json["role"],
        profile: json["profile"],
        lensId: json["lensId"],
        active: json["active"],
        isMarketplaceUser: json["isMarketplaceUser"],
        location: json["location"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : UpdatedAt.fromJson(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "role": role,
        "profile": profile,
        "lensId": lensId,
        "active": active,
        "isMarketplaceUser": isMarketplaceUser,
        "location": location,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toJson(),
    };
}

class UpdatedAt {
    String? val;

    UpdatedAt({
        this.val,
    });

    factory UpdatedAt.fromJson(Map<String, dynamic> json) => UpdatedAt(
        val: json["val"],
    );

    Map<String, dynamic> toJson() => {
        "val": val,
    };
}

class Metadata {
    String? host;
    int? port;
    String? latencyMs;

    Metadata({
        this.host,
        this.port,
        this.latencyMs,
    });

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        host: json["host"],
        port: json["port"],
        latencyMs: json["latency_ms"],
    );

    Map<String, dynamic> toJson() => {
        "host": host,
        "port": port,
        "latency_ms": latencyMs,
    };
}
