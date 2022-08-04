import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/utilities/global_events.dart';
import 'package:shuttla/ui/screens/driver/driver_complete_fragment.dart';
import 'package:shuttla/ui/screens/driver/driver_enroute_fragment.dart';
import 'package:shuttla/ui/screens/driver/selected_station_fragment.dart';
import 'package:shuttla/ui/screens/shared/select_busstop_fragment.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen();
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DriverHomeBloc, DriverHomeState>(
        listener: (ctx, state) {
          if (state is DriverEnrouteState)
            showBottomSheet(
              context: ctx,
              backgroundColor: Colors.transparent,
              builder: (ctx) => DriverEnrouteFragment(),
            );
          if (state is DriverPickupState)
            showBottomSheet(
              context: ctx,
              backgroundColor: Colors.transparent,
              builder: (ctx) => DriverCompleteFragment(),
            );
          if (state is DriverIdleState && state.completedSession)
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text("Successfully completed session"),
                  actions: [
                    BoxButton.rounded(
                      text: "Okay",
                      backgroundColor: Theme.of(context).primaryColorDark,
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              },
            );
        },
        child: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(5.377232, 7.000225), zoom: 16),
                myLocationButtonEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  this.mapController = controller;
                },
                markers: {},
                circles: {},
                polylines: {},
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(0, 0),
                        spreadRadius: 3,
                        blurRadius: 3,
                    )
                  ],
                ),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  iconSize: 30,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Builder(builder: (context) {
                    return SizedBox(
                      width: double.infinity,
                      child: BoxButton.rounded(
                        text: "See Stations",
                        onPressed: () => _seeStations(context),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _seeStations(BuildContext context) {
    showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.8,
            minChildSize: 0.5,
            builder: (context, controller) {
              return SelectStationFragment(
                controller,
                title: "Select Station",
                description: "Select which station you'd like to pickup from.",
                itemSelectAction: (Station station) {
                  Navigator.pop(context);
                  showBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SelectedStationFragment(station),
                  );
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(LatLng(5.377242, 7.000225)));
                },
              );
            },
          );
        });
  }

  late StreamSubscription logOutListener;

  @override
  void initState() {
    super.initState();
    logOutListener = eventBus.on<LogOutEvent>().listen((event) {
      print("Driver: Logged out because: ${event.reason}");
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.loginScreen,
        (route) => route.settings.name == RouteNames.loginScreen,
      );
    });
  }

  @override
  void dispose() {
    logOutListener.cancel();
    super.dispose();
  }
}
