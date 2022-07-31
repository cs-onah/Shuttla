import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class CreateStationScreen extends StatefulWidget {
  const CreateStationScreen({Key? key}) : super(key: key);
  @override
  State<CreateStationScreen> createState() => _CreateStationScreenState();
}

class _CreateStationScreenState extends State<CreateStationScreen> {
  Position? currentLocation;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    currentLocation = await LocationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Station"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () async {
              currentLocation = await Navigator.of(context).pushNamed(
                RouteNames.locationSelectScreen,
              );
            },
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.grey[200]),
              child: Column(
                children: [
                  Icon(Icons.add_location_alt_outlined, size: 60),
                  SizedBox(height: 20),
                  Text("Pick Location"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          BoxTextField(hintText: "Station Name"),
          SizedBox(height: 12),
          BoxTextField(hintText: "Station Description"),
          SizedBox(height: 12),
          BoxTextField(hintText: "Station Name"),
        ],
      ),
    );
  }
}
