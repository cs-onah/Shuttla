import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
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
    );
  }
}
