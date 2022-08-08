import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//ignore: must_be_immutable
class DriverData extends Equatable {
  DriverData({
    required this.plateNumber,
    required this.carManufacturer,
    required this.carModel,
    required this.carColor,
    this.lastKnownLocation = const <double>[],
  });

  String plateNumber;
  String carManufacturer;
  String carModel;
  String carColor;
  List<double> lastKnownLocation;
  LatLng get latLng => LatLng(lastKnownLocation[0], lastKnownLocation[1]);

  DriverData copyWith(
          {String? plateNumber,
          String? carManufacturer,
          String? carModel,
          String? carColor,
          List<double>? lastKnownLocation}) =>
      DriverData(
        plateNumber: plateNumber ?? this.plateNumber,
        carManufacturer: carManufacturer ?? this.carManufacturer,
        carModel: carModel ?? this.carModel,
        carColor: carColor ?? this.carColor,
        lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      );

  factory DriverData.fromJson(String str) =>
      DriverData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DriverData.fromMap(Map<String, dynamic> json) => DriverData(
        plateNumber: json["plateNumber"] == null ? null : json["plateNumber"],
        carManufacturer:
            json["carManufacturer"] == null ? null : json["carManufacturer"],
        carModel: json["carModel"] == null ? null : json["carModel"],
        carColor: json["carColor"] == null ? null : json["carColor"],
        lastKnownLocation: json["lastKnownLocation"] == null
            ? <double>[] : List<double>.from(
              json["lastKnownLocation"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "plateNumber": plateNumber,
        "carManufacturer": carManufacturer,
        "carModel": carModel,
        "carColor": carColor,
        "lastKnownLocation": lastKnownLocation,
      };

  @override
  List<Object?> get props => [
        plateNumber,
        carManufacturer,
        carModel,
        carColor,
        lastKnownLocation,
      ];
}
