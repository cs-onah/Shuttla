// To parse this JSON data, do
//
//     final station = stationFromMap(jsonString);

import 'dart:convert';

class Station {
  Station({
    required this.stationName,
    required this.coordinates,
    required this.createdDate,
    this.driverId,
    this.description,
    this.driverName,
    this.plateNumber,
  });

  String stationName;
  String? description;
  ///format: LatLng
  List<double> coordinates;
  String createdDate;
  String? driverId;
  String? driverName;
  String? plateNumber;

  Station copyWith({
    String? stationName,
    String? description,
    List<double>? coordinates,
    String? createdDate,
    String? driverId,
    String? driverName,
    String? plateNumber,
  }) =>
      Station(
        stationName: stationName ?? this.stationName,
        description: description ?? this.description,
        coordinates: coordinates ?? this.coordinates,
        createdDate: createdDate ?? this.createdDate,
        driverId: driverId ?? this.driverId,
        driverName: driverName ?? this.driverName,
        plateNumber: plateNumber ?? this.plateNumber,
      );

  factory Station.fromJson(String str) => Station.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Station.fromMap(Map<String, dynamic> json) => Station(
    stationName: json["station_name"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    createdDate: json["created_date"],
    driverId: json["driver_id"],
    driverName: json["driver_name"],
    plateNumber: json["plate_number"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "station_name": stationName,
    "description" : description,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "created_date": createdDate,
    "driver_id": driverId,
    "driver_name": driverName,
    "plate_number": plateNumber,
  };
}

///{
//     "station_name" : "hey",
//     "coordinates" : [6.943, 8.126],
//     "created_date" : "hdk",
//     "driver_id" : "",
//     "driver_name" : "",
//     "plate_number" : "driver_plate_number"
// }