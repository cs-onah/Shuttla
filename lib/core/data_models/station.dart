// To parse this JSON data, do
//
//     final station = stationFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/core/data_models/user_data.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/utilities/utility.dart';

class Station {
  Station({
    required this.stationName,
    required this.coordinates,
    required this.createdDate,
    required this.stationId,
    required this.reference,
    this.lastPickupTime,
    this.waitingPassengers = const [],
    this.driverId,
    this.description,
    this.driverName,
    this.plateNumber,
  });

  String stationId;
  DocumentReference reference;
  String stationName;
  String? description;
  ///format: LatLng
  List<double> coordinates;
  DateTime? lastPickupTime;
  DateTime createdDate;
  String? driverId;
  String? driverName;
  String? plateNumber;
  List<UserData> waitingPassengers;
  LatLng get latLng => LatLng(coordinates[0], coordinates[1]);
  String? get distanceFromDeviceString => ShuttlaUtility.convertDistance(LocationService.distanceFromDevice(latLng));
  double? get distanceFromDeviceFigure => LocationService.distanceFromDevice(latLng);

  Station copyWith({
    String? stationName,
    String? description,
    List<double>? coordinates,
    DateTime? lastPickupTime,
    DateTime? createdDate,
    List<UserData>? waitingPassengers,
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
        waitingPassengers: waitingPassengers ?? this.waitingPassengers,
        driverName: driverName ?? this.driverName,
        plateNumber: plateNumber ?? this.plateNumber,
        reference: this.reference,
        stationId: this.stationId,
      );

  // factory Station.fromJson(String str) => Station.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  // factory Station.fromMap(Map<String, dynamic> json) => Station(
  //   stationName: json["station_name"],
  //   coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  //   createdDate: json["created_date"],
  //   driverId: json["driver_id"],
  //   driverName: json["driver_name"],
  //   plateNumber: json["plate_number"],
  //   description: json["description"],
  // );

  factory Station.fromFirebaseSnapshot(DocumentSnapshot doc) => Station(
    stationId: doc.id,
    reference: doc.reference,
    stationName: doc.data()?["station_name"],
    coordinates: List<double>.from(doc.data()?["coordinates"].map((x) => x.toDouble())),
    lastPickupTime: DateTime.parse(doc.data()?["lastPickupTime"]),
    createdDate: DateTime.parse(doc.data()?["createdDate"]),
    waitingPassengers: List<UserData>.from(doc.data()?["waitingPassengers"].map((x) => UserData.fromMap(x))),
    driverId: doc.data()?["driver_id"],
    driverName: doc.data()?["driver_name"],
    plateNumber: doc.data()?["plate_number"],
    description: doc.data()?["description"],
  );

  Map<String, dynamic> toMap() => {
    "station_name": stationName,
    "description" : description,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "waitingPassengers" : List<Map<String, dynamic>>.from(waitingPassengers.map((x) => x.toMap())),
    "created_date": createdDate,
    "driver_id": driverId,
    "driver_name": driverName,
    "plate_number": plateNumber,
    "lastPickupTime": lastPickupTime?.toIso8601String(),
    "createdDate": createdDate.toIso8601String(),
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