// To parse this JSON data, do
//
//     final appUser = appUserFromMap(jsonString);

import 'dart:convert';
import 'driver_data.dart';
import 'user_data.dart';

class AppUser {
  AppUser({
    required this.userData,
    this.driverData,
    this.admin,
  });

  UserData userData;
  DriverData? driverData;
  Admin? admin;

  AppUser copyWith({
    UserData? userData,
    DriverData? driverData,
    Admin? admin,
  }) =>
      AppUser(
        userData: userData ?? this.userData,
        driverData: driverData ?? this.driverData,
        admin: admin ?? this.admin,
      );

  factory AppUser.fromJson(String str) => AppUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
    userData: UserData.fromMap(json["userData"]),
    driverData: json["driverData"] == null ? null : DriverData.fromMap(json["driverData"]),
    admin: json["admin"] == null ? null : Admin.fromMap(json["admin"]),
  );

  Map<String, dynamic> toMap() => {
    "userData":  userData.toMap(),
    "driverData": driverData?.toMap(),
    "admin":  admin?.toMap(),
  };
}

class Admin {
  Admin({
    required this.privileges,
  });

  String privileges;

  Admin copyWith({
    String? privileges,
  }) =>
      Admin(
        privileges: privileges ?? this.privileges,
      );

  factory Admin.fromJson(String str) => Admin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Admin.fromMap(Map<String, dynamic> json) => Admin(
    privileges: json["privileges"] == null ? null : json["privileges"],
  );

  Map<String, dynamic> toMap() => {
    "privileges":  privileges,
  };
}
