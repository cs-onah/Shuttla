import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/blocs/shuttla_home_bloc_contract.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/station_service.dart';
import 'package:shuttla/core/utilities/utility.dart';
import 'package:shuttla/ui/screens/admin/create_station_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/ui/widgets/driver_status_tile.dart';
import 'package:shuttla/ui/widgets/passenger_detail_tile.dart';
import 'package:shuttla/ui/widgets/station_detail_file.dart';

class AdminStationDetatilScreen extends StatefulWidget {
  final Station station;
  const AdminStationDetatilScreen(this.station);

  @override
  State<AdminStationDetatilScreen> createState() => _AdminStationDetatilScreenState();
}

class _AdminStationDetatilScreenState extends State<AdminStationDetatilScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white),
      height: SizeConfig.heightOf(80),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStationScreen(
                station: widget.station,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              iconSize: 30,
              color: Colors.black,
            ),
          ],
        ),
        body: StreamBuilder(
          stream: StationService().getStationDetailStream(widget.station),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> state) {
            if (!state.hasData) return Text("No data found");

            final station = Station.fromFirebaseSnapshot(state.data!);
            return ListView(
              padding: EdgeInsets.symmetric(
                  vertical: 20, horizontal: SizeConfig.widthOf(6)),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            station.stationName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(station.description ??
                              "N/A"),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    Icon(Icons.departure_board_outlined, size: 45)
                  ],
                ),
                SizedBox(height: 20),
                Divider(
                  height: 20,
                  color: Colors.black,
                ),
                StationDetailTile(
                  iconData: Icons.person,
                  text:
                  "${station.waitingPassengers
                      .length} passengers are currently waiting",
                  iconBgColor: Theme
                      .of(context)
                      .accentColor,
                ),
                StationDetailTile(
                  iconData: Icons.schedule,
                  text:
                  "Station created ${ShuttlaUtility.formatReadableDateTime(
                      widget.station.createdDate, timeInclusive: false)}",
                  iconBgColor: Colors.blueAccent,
                ),
                Divider(),
                DriverStatusTile(
                    station.approachingDrivers),
                Divider(),
                PassengerListTile(station.waitingPassengers),
                SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}