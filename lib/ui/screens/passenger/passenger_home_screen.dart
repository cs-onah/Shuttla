import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/ui/screens/passenger/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/dragging_widget.dart';

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
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: SizeConfig.widthOf(6)),
              child: Row(
                children: [
                  Spacer(),
                  CircleAvatar(child: Icon(Icons.menu, size: 40),
                    radius: 25,
                  ),
                ],
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
                  minChildSize: 0.15,
                  builder: (context, controller) => Card(
                    elevation: 30,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthOf(6),
                        vertical: 10,
                      ),
                      shrinkWrap: true,
                      controller: controller,
                      children: [
                        DragHandle(),
                        SizedBox(height: 10),
                        // if (controller.position.maxScrollExtent == controller.offset) Icon(Icons.close),
                        Text(
                          'Select Busstop',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Select where you want to be picked from.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 30),
                        for (int i = 0; i < 4; i++)
                          BusstopTile(isSelected: i == 0),

                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            backgroundColor:
                                Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            context.read<PassengerHomeBloc>().add(
                              PassengerFetchStationDetailEvent("stationId", "stationName")
                            );
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                builder: (context) {
                                  return StationDetailScreen("SEET Head", "1");
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
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
