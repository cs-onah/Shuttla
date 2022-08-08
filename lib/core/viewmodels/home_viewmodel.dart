import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/utilities/global_events.dart';

import '../../app.dart';

class HomeViewmodel extends ChangeNotifier {
  late GoogleMapController map;
  late StreamSubscription logOutListener;

  StreamSubscription? locationSubscription;

  Marker _locationMarker(LatLng location) => Marker(
    markerId: MarkerId("location_marker"),
    position: location,
    icon: BitmapDescriptor.defaultMarker,
  );

  Set<Polyline> polylineList = {};

  Set<Marker> mapMarkers = {};

  void listenForLogout(BuildContext context, {String userType = "Unknown user"}) {
    logOutListener = eventBus.on<LogOutEvent>().listen((event) {
      print("$userType: Logged out because: ${event.reason}");
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.loginScreen,
        (route) => route.settings.name == RouteNames.loginScreen,
      );
    });
  }

  void startLocationStream() async {
    bool permissionGranted = await LocationService.requestLocationPermission();
    BitmapDescriptor bitmap = await LocationService.initDeviceLocationBitmap();
    print("Generated bitmap");
    if (permissionGranted) {
      locationSubscription =
          LocationService.positionStream().listen((event) async {
        LocationService.devicePosition = event;
        final deviceMarker = Marker(
          markerId: MarkerId("device_location"),
          position: event.latLng,
          icon: bitmap,
          rotation: event.heading,
        );
        await map.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 16,
          ),
        ));
        mapMarkers.add(deviceMarker);
        notifyListeners();
      });
    }
  }

  void disposeDisposables() {
    logOutListener.cancel();
    locationSubscription?.cancel();
  }

  void showStationOnMap(Station station) {
    //Stop location stream
    locationSubscription?.cancel();

    //show location on map
    map.animateCamera(
        CameraUpdate.newLatLng(station.latLng));

    mapMarkers.add(_locationMarker(station.latLng));
    notifyListeners();
  }

  removeLocationMarkers(){
    mapMarkers.clear();
    notifyListeners();
  }

  void showNavigationLines(Station station) async {
    List<LatLng> routing = await LocationService.polylineBetween(destination: station.latLng);
    Polyline polyline = Polyline(polylineId: PolylineId("driver_navigation"),
      color: Colors.blue,
      points: routing,
      endCap: Cap.roundCap,
      width: 6,
    );
    polylineList.add(polyline);
    notifyListeners();
  }

  void clearPolylines() {
    polylineList.clear();
    notifyListeners();
  }
}
