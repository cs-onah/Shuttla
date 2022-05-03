import 'dart:convert';

import 'package:shuttla/constants/user_type_enum.dart';

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
  UserType? get userTypeEnum => getUserTypeFromString(userType);
  String get imageResourcePath => "images/Avatar-$imageResource.png";

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