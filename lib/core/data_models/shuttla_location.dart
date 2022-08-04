// To parse this JSON data, do
//
//     final shuttlaLocation = shuttlaLocationFromMap(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class ShuttlaLocation extends Equatable{
  ShuttlaLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.miscellaneous,
  });

  double? latitude;
  double? longitude;
  String? address;
  dynamic miscellaneous;

  ShuttlaLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    dynamic miscellaneous,
  }) =>
      ShuttlaLocation(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        miscellaneous: miscellaneous ?? this.miscellaneous,
      );

  factory ShuttlaLocation.fromJson(String str) => ShuttlaLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShuttlaLocation.fromMap(Map<String, dynamic> json) => ShuttlaLocation(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    address: json["address"],
    miscellaneous: json["miscellaneous"],
  );

  factory ShuttlaLocation.fromPosition(Position position) => ShuttlaLocation(
    latitude: position.latitude,
    longitude: position.latitude,
  );

  factory ShuttlaLocation.fromFirebaseCoordinates(List coordinates) {
    try{
      return ShuttlaLocation(
        latitude: coordinates[0],
        longitude: coordinates[1],
      );
    } catch(e){
      return ShuttlaLocation();
    }
  }

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "miscellaneous": miscellaneous,
  };

  @override
  List<Object?> get props => [longitude, latitude, address, miscellaneous];
}
