import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, offset: Offset(0,0), spreadRadius: 3, blurRadius: 3 )
                ]
              ),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.menu), color: Colors.black,
                  iconSize: 30,
                ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Builder(
                    builder: (context) {
                      return SizedBox(
                          width: double.infinity,
                          child: BoxButton.rounded(text: "See Stations", onPressed: ()=> _showStations(context),),);
                    }
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showStations(context) {
    showBottomSheet(context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 5,
        builder: (context){
          return Container(
            height: SizeConfig.heightOf(40),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Station',
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
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      IconButton(icon: Icon(Icons.close), onPressed: (){
                        Navigator.pop(context);
                      }, ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Which station",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search)
                    ),
                  ),
                  SizedBox(height: 10),
                  for (int i = 0; i < 4; i++)
                    BusstopTile(isSelected: i == 0),

                ],
              ),
            ),
          );
        },
    );
  }
}
