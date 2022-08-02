import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  /// Default location
  ///
  /// SMAT Complex Coordinates
  /// LatLng - 5.381590, 6.987601
  static Position DEFAULT_POSITION = Position(
    latitude: 5.381590,
    longitude: 6.987601,
    timestamp: DateTime.now(),
    isMocked: false,
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    floor: 0,
  );

  static Position? devicePosition = DEFAULT_POSITION;

  /// Returns current device Location
  static Future<Position?> getCurrentLocation() async {
    try {
      requestLocationPermission();
      devicePosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return devicePosition;
    } catch (e) {
      print("cannot get location: $e");
      return DEFAULT_POSITION;
    }
  }

  static double distanceFromDevice(LatLng location) {
    return Geolocator.distanceBetween(
      devicePosition!.latitude,
      devicePosition!.longitude,
      location.latitude,
      location.latitude,
    );
  }

  /// Checks and requests for Location Permission
  ///
  /// returns bool based on location permission status.
  static Future<bool> requestLocationPermission() async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      print("denied");
      LocationPermission permission = await Geolocator.requestPermission();
      return (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse);
    } else if (p == LocationPermission.deniedForever) {
      print("denied forever");
      Geolocator.openLocationSettings();
      return false;
    } else {
      return true;
    }
  }

  /// Provides a listenable location stream
  ///
  /// Usage: create a [StreamSubscription] to listen to stream.
  /// Remember to dispose [StreamSubscription] after use.
  static Stream<Position> positionStream() => Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 3),
        distanceFilter: 1,
      );
}

extension PositionAddOns on Position {
  LatLng get latLng => LatLng(
        this.latitude,
        this.longitude,
      );
}
