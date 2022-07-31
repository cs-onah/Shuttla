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

  static get defaultLocationLatLng => LatLng(
        DEFAULT_POSITION.latitude,
        DEFAULT_POSITION.longitude,
      );

  /// Returns current device Location
  static Future<Position> getCurrentLocation() async {
    try {
      requestLocationPermission();
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("cannot get location: $e");
      return DEFAULT_POSITION;
    }
  }

  /// Checks and requests for Location Permission
  ///
  /// returns bool based on location permission status.
  static Future requestLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      LocationPermission permission = await Geolocator.requestPermission();
      return (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse)
          ? true
          : false;
    } else
      return true;
  }

  /// Provides a listenable location stream
  ///
  /// Usage: create a [StreamSubscription] to listen to stream.
  /// Remember to dispose [StreamSubscription] after use.
  static Stream positionStream() => Geolocator.getPositionStream();
}
