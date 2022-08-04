import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/authentication_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';
import 'package:shuttla/core/viewmodels/home_viewmodel.dart';
import 'package:shuttla/ui/screens/shared/select_busstop_fragment.dart';
import 'package:shuttla/ui/screens/shared/station_detail_screen.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);
  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> with UiKit {

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();
    final homeModel = Provider.of<HomeViewmodel>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
              polylines: {},
            ),

            //Header
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: 20, horizontal: SizeConfig.widthOf(5)),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: FutureBuilder(
                    future: authBloc.currentUser(),
                    builder: (BuildContext context,
                        AsyncSnapshot<AppUser?> snapshot) {
                      if (!snapshot.hasData) return Container();
                      return GestureDetector(
                        // onTap: () => authBloc.add(AuthUserLogout()),
                        onTap: () => SessionManager.logout(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              foregroundImage: AssetImage(
                                  snapshot.data!.userData.imageResourcePath),
                              radius: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Hi ${snapshot.data?.userData.nickname ?? ""} 👋',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),

            //BottomSheet section
            BlocConsumer<PassengerHomeBloc, PassengerHomeState>(
                listener: (context, state) {
              if (state is PassengerErrorState) {
                showToastMessage(context, state.errorMessage);
              }

              if(state is PassengerPickupState){
                //Show dialog to allow Passenger select if they want to keep waiting
                // go to IdleState on okay clicked
                // go back to waiting state on 'keep waiting' clicked, and navigate to details screen
              }

              if(State is PassengerIdleState){
                Navigator.pushNamedAndRemoveUntil(context, RouteNames.passengerHomeScreen, (route) => false);
              }

            }, buildWhen: (oldState, newState) {
              return newState is PassengerWaitingState ||
                newState is PassengerIdleState;
            }, builder: (context, state) {
              if (state is PassengerWaitingState)
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: PassengerWaitingWidget(),
                );

              return DraggableScrollableSheet(
                initialChildSize: 0.3,
                maxChildSize: 0.8,
                minChildSize: 0.3,
                builder: (context, controller) => SelectStationFragment(
                  controller,
                  title: "Select Station",
                  description: "Select where you want to be picked from",
                  itemSelectAction: (Station station) {
                    context
                        .read<PassengerHomeBloc>()
                        .add(PassengerFetchStationDetailEvent(station));

                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      enableDrag: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      builder: (context) {
                        return StationDetailScreen(station);
                      },
                    );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //Listen for logout
    context.read<HomeViewmodel>().listenForLogout(context);
  }

  @override
  void dispose() {
    context.read<HomeViewmodel>().disposeDisposables();
    // HomeViewmodel.disposeDisposables();
    super.dispose();
  }
}

class PassengerWaitingWidget extends StatelessWidget {
  const PassengerWaitingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PassengerHomeBloc>(context);
    int totalPassengerCount = bloc.selectedStation?.waitingPassengers.length ?? 1;
    int otherPassengerCount = totalPassengerCount - 1;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bloc.selectedStation?.stationName ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("${bloc.selectedStation?.description ?? 'No description'}"),
                  ],
                ),
              ),
              SizedBox(width: 40),
              Icon(Icons.bus_alert,
                  size: 30, color: Theme.of(context).accentColor)
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Text(
            otherPassengerCount < 1 ? "You are the only passenger waiting in this station." :
            'You are waiting with $otherPassengerCount other passengers.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          Text(
            'Driver is approaching.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: BoxButton(
              text: "LEAVE",
              backgroundColor: Colors.red,
              onPressed: () {
                BlocProvider.of<PassengerHomeBloc>(context).add(
                  PassengerLeaveStationEvent(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
