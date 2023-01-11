import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/auth_service.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';

import '../../app.dart';

class HomeViewmodel extends ChangeNotifier {
  late GoogleMapController map;
  late StreamSubscription logOutListener;

  Marker? _deviceMarker;
  Set<Marker> busStationMarkers = {};

  StreamSubscription? locationSubscription;
  List<StreamSubscription>? approachingDriverLocationSubscription;

  Marker _genericMarker(LatLng location) => Marker(
        markerId: MarkerId("location_marker"),
        position: location,
        icon: BitmapDescriptor.defaultMarker,
      );

  Set<Polyline> polylineList = {};

  Set<Marker> mapMarkers = {};

  void listenForLogout(BuildContext context,
      {String userType = "Unknown user"}) {
    logOutListener = eventBus.on<LogOutEvent>().listen((event) {
      resetLocationMarkers();
      print("$userType: Logged out because: ${event.reason}");
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.loginScreen,
        (route) => route.settings.name == RouteNames.loginScreen,
      );
    });
  }

  void startLocationStream({
    bool showPolylines = false,
    bool logLastLocation = false,
    Station? station,
  }) async {
    assert(showPolylines && station != null || !showPolylines,
        "Station cannot be null if showPolylines=true");
    assert(logLastLocation && station != null || !logLastLocation,
        "Station cannot be null if logLastLocation=true");
    locationSubscription?.cancel();
    bool permissionGranted = await LocationService.requestLocationPermission();
    BitmapDescriptor bitmap = await LocationService.initDeviceLocationBitmap();

    if (permissionGranted) {
      locationSubscription =
          LocationService.positionStream().listen((event) async {
        LocationService.devicePosition = event;
        updateUserLocationMarker(event, bitmap);
        if (showPolylines) showNavigationLines(station!);
        if (logLastLocation) updateDriverLocation(event);
        await map.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 16,
          ),
        ));
      });
    }
  }

  void disposeDisposables() {
    logOutListener.cancel();
    locationSubscription?.cancel();
    cancelApproachingDriverSubscriptions();
  }

  void cancelApproachingDriverSubscriptions() {
    approachingDriverLocationSubscription?.map((e) => e.cancel());
    approachingDriverLocationSubscription?.clear();
    mapMarkers = {};
    mapMarkers.addAll(busStationMarkers);
    if (_deviceMarker != null) mapMarkers.add(_deviceMarker!);
    notifyListeners();
    print("Discarded all driver location streams");
  }

  void showStationOnMap(Station station) {
    locationSubscription?.cancel();
    map.animateCamera(CameraUpdate.newLatLng(station.latLng));
    notifyListeners();
  }

  resetLocationMarkers() {
    mapMarkers.clear();
    notifyListeners();
  }

  void showNavigationLines(Station station) async {
    List<LatLng> routing =
        await LocationService.polylineBetween(destination: station.latLng);
    Polyline polyline = Polyline(
      polylineId: PolylineId("driver_navigation"),
      color: Colors.blue,
      points: routing,
      endCap: Cap.roundCap,
      width: 6,
    );
    polylineList.add(polyline);
    notifyListeners();
  }

  void initiateOnRouteMap(Station station) => startLocationStream(
      showPolylines: true, station: station, logLastLocation: true);

  void clearPolylines() {
    polylineList.clear();
    notifyListeners();
  }

  List<AppUser> approachingDrivers = [];
  void listenToApproachingDrivers(Station selectedStation) async {
    //Check if driver number changed
    if (selectedStation.approachingDrivers.length == approachingDrivers.length)
      return;
    //cancel existing driver location streams
    if (approachingDriverLocationSubscription?.isNotEmpty ?? false)
      cancelApproachingDriverSubscriptions();
    //return if there are no drivers to track
    if (selectedStation.approachingDrivers.isEmpty) return;
    approachingDrivers = selectedStation.approachingDrivers;

    BitmapDescriptor driverBitmap =
        await LocationService.initDriverLocationBitmap();

    approachingDriverLocationSubscription = selectedStation.approachingDrivers
        .map(
          (e) => FirebaseFirestore.instance
              .collection(CollectionName.USERS)
              .doc(e.userData.userId)
              .snapshots()
              .listen((event) {
            AppUser driver = AppUser.fromMap(event.data()!);
            if (driver.driverData!.lastKnownLocation.isEmpty) return;
            mapMarkers.add(Marker(
              markerId: MarkerId("${e.userData.userId}"),
              position: driver.driverData!.latLng,
              icon: driverBitmap,
              rotation: driver.driverData!.lastKnownLocation[2],
            ));
            notifyListeners();
          }),
        )
        .toList();
  }

  void setupBusStationMarkers(List<Station> stations) async {
    BitmapDescriptor stationBitmap = await LocationService.initStationLocationBitmap();
    busStationMarkers.addAll(
      stations.map(
        (e) => Marker(
          markerId: MarkerId(e.stationName),
          position: e.latLng,
          icon: stationBitmap,
        ),
      ),
    );
    mapMarkers.addAll(busStationMarkers);
    notifyListeners();
  }

  void updateDriverLocation(Position newPosition) {
    try {
      AppUser driver = SessionManager.user!;
      AuthService().updateDriver(driver.copyWith(
          driverData: driver.driverData!.copyWith(
            lastKnownLocation: [
              newPosition.latitude,
              newPosition.longitude,
              newPosition.heading
            ],
          ),),);
    } catch (e) {}
  }

  void updateUserLocationMarker(Position event, BitmapDescriptor bitmap) {
    _deviceMarker = Marker(
      markerId: MarkerId("device_location"),
      position: event.latLng,
      icon: bitmap,
      rotation: event.heading,
    );
    mapMarkers.add(_deviceMarker!);
    notifyListeners();
  }
}
