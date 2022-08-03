import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';
import 'package:shuttla/ui/screens/admin/create_station_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StationCubit>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Stations",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => SessionManager.logout(),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 50,
                child: TextButton.icon(
                  onPressed: () => Navigator.pushNamed(
                      context, RouteNames.createStationScreen),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "New Station     ",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<StationCubit, StationState>(
              builder: (context, state) {
                if (state is LoadingStationState)
                  return Center(child: CircularProgressIndicator());

                if (state is LoadedStationState && state.stations.isNotEmpty)
                  return RefreshIndicator(
                    onRefresh: () async {
                      await bloc.getStations(showLoader: false);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      itemCount: state.stations.length,
                      itemBuilder: (context, index) => StationTile(
                        station: state.stations[index],
                      ),
                    ),
                  );

                return Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No Station Found!"),
                    SizedBox(height: 10),
                    TextButton(onPressed: ()=> bloc.getStations(), child: Text("Refresh")),
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  late StreamSubscription logOutListener;

  @override
  void initState() {
    super.initState();
    logOutListener = eventBus.on<LogOutEvent>().listen((event) {
      print("Admin: Logged out because: ${event.reason}");
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.loginScreen,
        (route) => route.settings.name == RouteNames.loginScreen,
      );
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      BlocProvider.of<StationCubit>(context).getStations();
    });
  }

  @override
  void dispose() {
    logOutListener.cancel();
    super.dispose();
  }
}

class StationTile extends StatelessWidget {
  final Station station;
  const StationTile({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StationCubit>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.stationName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 5),
                    Text(
                        "${station.coordinates[0].toStringAsFixed(5)}, ${station.coordinates[1].toStringAsFixed(5)}")
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 5),
                    Text("0 waiting")
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateStationScreen(
                      station: station,
                    ),
                  ),
                ),
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () => bloc.deleteStation(station),
              icon: Icon(Icons.delete),
              color: Colors.red),
        ],
      ),
    );
  }
}
