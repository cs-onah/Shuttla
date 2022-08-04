import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/services/station_service.dart';
import 'package:shuttla/core/utilities/utility.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../onboarding/select_user_screen.dart';

class StationDetailScreen extends StatefulWidget {
  final Station station;
  final UserType userRole;
  const StationDetailScreen(this.station, {this.userRole = UserType.PASSENGER});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  StreamSubscription? stationDetailStream;
  late Station station;
  @override
  void initState() {
    station = widget.station;
    super.initState();
  }

  @override
  void dispose() {
    stationDetailStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final passengerBloc = BlocProvider.of<PassengerHomeBloc>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white),
      height: SizeConfig.heightOf(80),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              iconSize: 30,
              color: Colors.black,
            ),
          ],
        ),
        body: ListView(
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
                        widget.station.stationName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ), SizedBox(height: 10),
                      Text(widget.station.description ?? ""),
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
              text: "5 people are currently waiting",
              iconBgColor: Theme.of(context).accentColor,
            ),
            if(widget.station.distanceFromDeviceString != null) StationDetailTile(
              iconData: Icons.straighten,
              text: ShuttlaUtility.convertDistance(widget.station.distanceFromDeviceFigure) ?? "",
              iconBgColor: Colors.amber[600],
            ),
            StationDetailTile(
              iconData: Icons.schedule,
              text: "Station created ${ShuttlaUtility.formatReadableDateTime(widget.station.createdDate, timeInclusive: false)}",
              iconBgColor: Colors.blueAccent,
            ),
            Divider(),
            DriverStatusTile("none"),
            Divider(),
            SizedBox(height: 40),
            Builder(
              builder: (context) {
                switch (widget.userRole) {
                  case UserType.DRIVER:
                    return _driverActionWidget(context);
                  case UserType.PASSENGER:
                  default:
                    return _passengerActionWidget(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  BoxButton _passengerActionWidget(BuildContext context) {
    return BoxButton.purple(
      text: "JOIN WAIT",
      onPressed: () {
        context.read<PassengerHomeBloc>().add(
          PassengerJoinStationEvent(),
        );
        Navigator.pop(context);
      },
      // onPressedWithNotifier: (valueNotifier) async{
      //   valueNotifier.value = true;
      //   //Network request
      //   await Future.delayed(Duration(seconds: 3));
      //
      //   valueNotifier.value = false;
      // },
    );
  }

  Widget _driverActionWidget(BuildContext context) {
    return BoxButton.purple(
      text: "SELECT STATION",
      onPressed: () {
        context.read<DriverHomeBloc>().add(
          DriverEnrouteEvent("stationId", "stationName"),
        );
        Navigator.pop(context);
      },
    );
  }
}

class StationDetailTile extends StatelessWidget {
  final IconData? iconData;
  final Color? iconBgColor;
  final String text;
  const StationDetailTile({
    Key? key,
    this.iconData,
    this.text = "",
    this.iconBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconData == null
              ? SizedBox(width: 30)
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: iconBgColor ?? Colors.black45,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(iconData, size: 25, color: Colors.white),
                  )),
          SizedBox(width: 25),
          Expanded(
            child: Text(
              '$text',
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverStatusTile extends StatelessWidget {
  final String status;
  final String? driverDetails;

  const DriverStatusTile(this.status, {this.driverDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.black45,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.bus_alert, size: 25, color: Colors.white),
              )),
          SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'No driver approaching at the moment.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
