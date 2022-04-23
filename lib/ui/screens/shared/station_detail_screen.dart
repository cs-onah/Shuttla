import 'package:flutter/material.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../select_user_screen.dart';

class StationDetailScreen extends StatelessWidget {
  final String stationName, stationId;
  final UserType userRole;
  const StationDetailScreen(this.stationName, this.stationId,
      {this.userRole = UserType.PASSENGER});

  @override
  Widget build(BuildContext context) {
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
              vertical: 30, horizontal: SizeConfig.widthOf(6)),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'SEET Head Station',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
            StationDetailTile(
              iconData: Icons.straighten,
              text: "40 meters away from your current location",
              iconBgColor: Colors.amber[600],
            ),
            StationDetailTile(
              iconData: Icons.schedule,
              text: "Station created 23rd July",
              iconBgColor: Colors.blueAccent,
            ),
            Divider(),
            DriverStatusTile("none"),
            Divider(),
            SizedBox(height: 40),
            Builder(
              builder: (context) {
                switch (userRole) {
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
          PassengerJoinStationEvent(stationId, stationName),
        );
        Navigator.pop(context);
      },
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
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
