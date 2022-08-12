import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/station_service.dart';
import 'package:shuttla/core/utilities/utility.dart';
import 'package:shuttla/ui/screens/admin/create_station_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/driver_status_tile.dart';
import 'package:shuttla/ui/widgets/passenger_detail_tile.dart';
import 'package:shuttla/ui/widgets/station_detail_file.dart';

class AdminStationDetatilScreen extends StatefulWidget {
  final Station station;
  const AdminStationDetatilScreen(this.station);
  @override
  State<AdminStationDetatilScreen> createState() =>
      _AdminStationDetatilScreenState();
}

class _AdminStationDetatilScreenState extends State<AdminStationDetatilScreen> {
  late Station station;

  @override
  void initState() {
    station = widget.station;
    super.initState();
  }

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
                station: station,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                iconSize: 40,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: StationService().getStationDetailStream(widget.station),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> state) {
            if (!state.hasData) return Text("No data found");

            final station = Station.fromFirebaseSnapshot(state.data!);
            this.station = station;

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
                          Text(station.description ?? "N/A"),
                          SizedBox(height: 10),
                          Row(
                           children: [ Text("Status:"),
                            SizedBox(width: 5),
                            Text(station.isClosed? "CLOSED" : "OPEN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: station.isClosed ? Colors.red : Colors.green,
                              ),
                            )
                           ]
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    Icon(Icons.departure_board_outlined, size: 45)
                  ],
                ),
                SizedBox(height: 20),
                Divider(height: 20, color: Colors.black),
                StationDetailTile(
                  iconData: Icons.person,
                  text:
                      "${station.waitingPassengers.length} passengers are currently waiting",
                  iconBgColor: Theme.of(context).accentColor,
                ),
                StationDetailTile(
                  iconData: Icons.schedule,
                  text:
                      "Station created ${ShuttlaUtility.formatReadableDateTime(station.createdDate, timeInclusive: false)}",
                  iconBgColor: Colors.blueAccent,
                ),
                Divider(),
                DriverStatusTile(station.approachingDrivers),
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
