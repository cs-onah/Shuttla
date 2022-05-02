// To parse this JSON data, do
//
//     final appUser = appUserFromMap(jsonString);

import 'dart:convert';

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

class DriverData {
  DriverData({
    required this.plateNumber,
    required this.carManufacturer,
    required this.carModel,
    required this.carColor,
  });

  String plateNumber;
  String carManufacturer;
  String carModel;
  String carColor;

  DriverData copyWith({
    String? plateNumber,
    String? carManufacturer,
    String? carModel,
    String? carColor,
  }) =>
      DriverData(
        plateNumber: plateNumber ?? this.plateNumber,
        carManufacturer: carManufacturer ?? this.carManufacturer,
        carModel: carModel ?? this.carModel,
        carColor: carColor ?? this.carColor,
      );

  factory DriverData.fromJson(String str) => DriverData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DriverData.fromMap(Map<String, dynamic> json) => DriverData(
    plateNumber: json["plateNumber"] == null ? null : json["plateNumber"],
    carManufacturer: json["carManufacturer"] == null ? null : json["carManufacturer"],
    carModel: json["carModel"] == null ? null : json["carModel"],
    carColor: json["carColor"] == null ? null : json["carColor"],
  );

  Map<String, dynamic> toMap() => {
    "plateNumber": plateNumber,
    "carManufacturer": carManufacturer,
    "carModel": carModel,
    "carColor": carColor,
  };
}

class UserData {
  UserData({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.imageResource,
    required this.userType,
  });

  String userId;
  String nickname;
  String email;
  String imageResource;
  String userType;

  UserData copyWith({
    String? nickname,
    String? email,
    String? userId,
    String? imageResource,
    String? userType,
  }) =>
      UserData(
        nickname: nickname ?? this.nickname,
        email: email ?? this.email,
        userId: userId ?? this.userId,
        imageResource: imageResource ?? this.imageResource,
        userType: userType ?? this.userType,
      );

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    nickname: json["nickname"] == null ? null : json["nickname"],
    email: json["email"] == null ? null : json["email"],
    userId: json["userId"] == null ? null : json["userId"],
    imageResource: json["imageResource"] == null ? null : json["imageResource"],
    userType: json["userType"] == null ? null : json["userType"],
  );

  Map<String, dynamic> toMap() => {
    "nickname": nickname,
    "email": email,
    "userId": userId,
    "imageResource": imageResource,
    "userType": userType,
  };
}
