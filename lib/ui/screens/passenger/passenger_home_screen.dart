import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/ui/screens/shared/select_busstop_fragment.dart';
import 'package:shuttla/ui/screens/shared/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);
  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PassengerHomeBloc>(context, listen: false)
        .add(PassengerFetchAllStationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(5.377232, 7.000225), zoom: 16),
              myLocationButtonEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {},
              markers: {},
              circles: {},
              polylines: {},
            ),

            //Header
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: SizeConfig.widthOf(5)),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      foregroundImage: AssetImage("images/Avatar-4.png"),
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Hi Ebuka 👋',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                  ],
                ),
              ),
            ),

            //BottomSheet section
            BlocBuilder<PassengerHomeBloc, PassengerHomeState>(
                builder: (context, state) {
              if (state is PassengerWaitingState)
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: PassengerWaitingWidget(),
                );
              else
                return DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  maxChildSize: 0.8,
                  minChildSize: 0.3,
                  builder: (context, controller) => SelectStationFragment(
                      controller,
                    title: "Select Station",
                    description: "Select where you want to be picked from.",
                    itemSelectAction: (a) {
                      context.read<PassengerHomeBloc>().add(
                          PassengerFetchStationDetailEvent(
                              "stationId", "stationName"));
                      showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          builder: (context) {
                            return StationDetailScreen("SEET Head", "1");
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
}

class PassengerWaitingWidget extends StatelessWidget {
  const PassengerWaitingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  'SEET head Station',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
            'You are waiting with 5 other passengers.',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Driver is approaching.',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: BoxButton(
              text: "LEAVE",
              backgroundColor: Colors.red,
              onPressed: () {
                BlocProvider.of<PassengerHomeBloc>(context).add(
                  PassengerLeaveStationEvent("", ""),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
