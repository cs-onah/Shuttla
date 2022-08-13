import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';
import 'package:shuttla/core/viewmodels/home_viewmodel.dart';
import 'package:shuttla/ui/screens/driver/driver_complete_fragment.dart';
import 'package:shuttla/ui/screens/driver/driver_enroute_fragment.dart';
import 'package:shuttla/ui/screens/driver/selected_station_fragment.dart';
import 'package:shuttla/ui/screens/shared/app_drawer.dart';
import 'package:shuttla/ui/screens/shared/select_busstop_fragment.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen();
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> with UiKit{
  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeViewmodel>(context);
    return BlocProvider(
      create: (context)=> DriverHomeBloc(),
      child: Scaffold(
        drawer: AppDrawer(),
        body: BlocListener<DriverHomeBloc, DriverHomeState>(
          listener: (ctx, state) async {
            if(state is DriverErrorState)
              showToastMessage(context, state.errorMessage);
            if (state is DriverEnrouteState){
              // homeModel.showNavigationLines(state.station);
              homeModel.initiateOnRouteMap(state.station);
              showBottomSheet(
                context: ctx,
                backgroundColor: Colors.transparent,
                builder: (ctx) => DriverEnrouteFragment(),
              );
            }
            if (state is DriverPickupState)
              showBottomSheet(
                context: ctx,
                backgroundColor: Colors.transparent,
                builder: (ctx) => DriverCompleteFragment(),
              );
            if (state is DriverIdleState){
              homeModel.clearPolylines();
              homeModel.startLocationStream();

              if(state.completedSession)
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Success"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      content: Text("Successfully completed session"),
                      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
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
            }

          },
          child: SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                  CameraPosition(target: LatLng(5.377232, 7.000225), zoom: 16),
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    homeModel.map = controller;
                    homeModel.startLocationStream();
                  },
                  markers: homeModel.mapMarkers,
                  circles: {},
                  polylines: homeModel.polylineList,
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
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: Icon(Icons.menu),
                        color: Colors.black,
                        iconSize: 30,
                      );
                    }
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
                          onPressed: () => _seeStations(context, homeModel),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _seeStations(BuildContext context, HomeViewmodel homeViewmodel) {
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
                  homeViewmodel.showStationOnMap(station);
                },
              );
            },
          );
        });
  }


  @override
  void initState() {
    super.initState();
    context.read<HomeViewmodel>().listenForLogout(context, userType: "Driver");
  }

  @override
  void dispose() {
    context.read<HomeViewmodel>().disposeDisposables();
    super.dispose();
  }
}
