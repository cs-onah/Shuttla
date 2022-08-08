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

  StreamSubscription? locationSubscription;
  List<StreamSubscription>? approachingDriverLocationSubscription;

  Marker _locationMarker(LatLng location) => Marker(
        markerId: MarkerId("location_marker"),
        position: location,
        icon: BitmapDescriptor.defaultMarker,
      );

  Set<Polyline> polylineList = {};

  Set<Marker> mapMarkers = {};

  void listenForLogout(BuildContext context,
      {String userType = "Unknown user"}) {
    logOutListener = eventBus.on<LogOutEvent>().listen((event) {
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
    assert(logLastLocation && station != null || !showPolylines,
        "Station cannot be null if logLastLocation=true");
    locationSubscription?.cancel();
    bool permissionGranted = await LocationService.requestLocationPermission();
    BitmapDescriptor bitmap = await LocationService.initDeviceLocationBitmap();

    if (permissionGranted) {
      locationSubscription =
          LocationService.positionStream().listen((event) async {
        LocationService.devicePosition = event;
        _deviceMarker ??= Marker(
          markerId: MarkerId("device_location"),
          position: event.latLng,
          icon: bitmap,
          rotation: event.heading,
        );
        if (showPolylines) {
          List<LatLng> routing = await LocationService.polylineBetween(
              destination: station!.latLng);
          Polyline polyline = Polyline(
            polylineId: PolylineId("driver_navigation"),
            color: Colors.blue,
            points: routing,
            endCap: Cap.roundCap,
            width: 6,
          );
          polylineList.add(polyline);
        }
        if (logLastLocation) {
          try {
            AppUser driver = SessionManager.user!;
            AuthService().updateDriver(driver.copyWith(
                driverData: driver.driverData!.copyWith(
              lastKnownLocation: [event.latitude, event.longitude, event.heading],
            )));
          } catch (e) {}
        }
        await map.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 16,
          ),
        ));
        mapMarkers.add(_deviceMarker!);
        notifyListeners();
      });
    }
  }

  void disposeDisposables() {
    logOutListener.cancel();
    locationSubscription?.cancel();
    cancelApproachingDriverSubscriptions();
  }

  void cancelApproachingDriverSubscriptions(){
    approachingDriverLocationSubscription?.map((e) => e.cancel());
    approachingDriverLocationSubscription?.clear();
    mapMarkers = {};
    if(_deviceMarker != null) mapMarkers.add(_deviceMarker!);
    notifyListeners();
    print("Discarded all driver location streams");
  }

  void showStationOnMap(Station station) {
    //Stop location stream
    locationSubscription?.cancel();

    //show location on map
    map.animateCamera(CameraUpdate.newLatLng(station.latLng));

    mapMarkers.add(_locationMarker(station.latLng));
    notifyListeners();
  }

  removeLocationMarkers() {
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
    if(selectedStation.approachingDrivers.length == approachingDrivers.length) return;
    if(approachingDriverLocationSubscription?.isNotEmpty ?? false) cancelApproachingDriverSubscriptions();
    BitmapDescriptor driverBitmap = await LocationService.initDriverLocationBitmap();
    approachingDrivers = selectedStation.approachingDrivers;
    cancelApproachingDriverSubscriptions();
    if(selectedStation.approachingDrivers.isEmpty) return;
    approachingDriverLocationSubscription = selectedStation.approachingDrivers.map((e) =>
        FirebaseFirestore.instance.collection(CollectionName.USERS).doc(e.userData.userId).snapshots().listen((event) {
          AppUser driver = AppUser.fromMap(event.data()!);
          if(driver.driverData!.lastKnownLocation.isEmpty) return;
          mapMarkers.add(
              Marker(
                markerId: MarkerId("${e.userData.userId}"),
                position: driver.driverData!.latLng,
                icon: driverBitmap,
                rotation: driver.driverData!.lastKnownLocation[2],
              )
          );
          notifyListeners();
        }),
    ).toList();
  }
}
