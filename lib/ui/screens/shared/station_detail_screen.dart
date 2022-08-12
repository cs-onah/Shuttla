import 'package:flutter/material.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/blocs/shuttla_home_bloc_contract.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/utilities/utility.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/ui/widgets/driver_status_tile.dart';
import 'package:shuttla/ui/widgets/station_detail_file.dart';

class StationDetailScreen extends StatefulWidget {
  final Station station;
  final UserType userRole;
  final ShuttlaHomeBloc bloc;
  const StationDetailScreen(this.station, this.bloc, {this.userRole = UserType.PASSENGER});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
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
                if(widget.bloc is DriverHomeBloc)
                  widget.bloc.add(DriverResetEvent());
                if(widget.bloc is PassengerHomeBloc)
                  widget.bloc.add(PassengerResetEvent());
              },
              icon: Icon(Icons.close),
              iconSize: 30,
              color: Colors.black,
            ),
          ],
        ),
        body: BlocBuilder(
          bloc: widget.bloc as Bloc,
          builder: (context, state) => ListView(
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
                          widget.bloc.selectedStation?.stationName ??
                              widget.station.stationName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(widget.bloc.selectedStation?.description ??
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
                    "${widget.bloc.selectedStation?.waitingPassengers.length ?? 0} passengers are currently waiting",
                iconBgColor: Theme.of(context).accentColor,
              ),
              if (widget.station.distanceFromDeviceString != null)
                StationDetailTile(
                  iconData: Icons.straighten,
                  text: ShuttlaUtility.convertDistance(
                          widget.station.distanceFromDeviceFigure) ??
                      "",
                  iconBgColor: Colors.amber[600],
                ),
              StationDetailTile(
                iconData: Icons.schedule,
                text:
                    "Station created ${ShuttlaUtility.formatReadableDateTime(widget.station.createdDate, timeInclusive: false)}",
                iconBgColor: Colors.blueAccent,
              ),
              Divider(),
              DriverStatusTile(
                  widget.bloc.selectedStation?.approachingDrivers ?? []),
              Divider(),
              SizedBox(height: 20),
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
    );
  }

  Widget _driverActionWidget(BuildContext context) {
    return BoxButton.purple(
      text: "SELECT STATION",
      onPressed: () {
        context.read<DriverHomeBloc>().add(
              DriverEnrouteEvent(widget.station),
            );
        Navigator.pop(context);
      },
    );
  }
}