import 'dart:convert';

import 'package:equatable/equatable.dart';

class DriverData extends Equatable {
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

  factory DriverData.fromJson(String str) =>
      DriverData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DriverData.fromMap(Map<String, dynamic> json) => DriverData(
        plateNumber: json["plateNumber"] == null ? null : json["plateNumber"],
        carManufacturer:
            json["carManufacturer"] == null ? null : json["carManufacturer"],
        carModel: json["carModel"] == null ? null : json["carModel"],
        carColor: json["carColor"] == null ? null : json["carColor"],
      );

  Map<String, dynamic> toMap() => {
        "plateNumber": plateNumber,
        "carManufacturer": carManufacturer,
        "carModel": carModel,
        "carColor": carColor,
      };

  @override
  List<Object?> get props => [
        plateNumber,
        carManufacturer,
        carModel,
        carColor,
      ];
}
