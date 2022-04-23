import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/ui/screens/shared/select_busstop_fragment.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen();
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              onMapCreated: (GoogleMapController controller) {},
              markers: {},
              circles: {},
              polylines: {},
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
                      blurRadius: 3)
                ],
              ),
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu),
                color: Colors.black,
                iconSize: 30,
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
                      onPressed: () => _seeStations(context),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

   _seeStations(BuildContext context) {
     showBottomSheet(
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: 0.8,
            minChildSize: 0.3,
            builder: (context, controller) {
              return SelectStationFragment(
                controller,
                title: "Select Station",
                description: "Select where you want to be picked from.",
                itemSelectAction: (a) {},
              );
            },
          );
        });
  }
}
