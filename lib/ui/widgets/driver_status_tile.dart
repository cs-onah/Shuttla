import 'package:flutter/material.dart';
import 'package:shuttla/core/data_models/app_user.dart';

class DriverStatusTile extends StatelessWidget {
  final List<AppUser> drivers;

  const DriverStatusTile(this.drivers);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: drivers.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Driver(s) Approaching",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...drivers.map(
                (e) => Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      foregroundImage:
                      AssetImage(e.userData.imageResourcePath)),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${e.userData.nickname}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                          "${e.driverData!.carManufacturer}, ${e.driverData!.carModel}"),
                      SizedBox(height: 10),
                      Text("${e.driverData!.plateNumber}"),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.black45,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                Icon(Icons.bus_alert, size: 25, color: Colors.white),
              )),
          SizedBox(width: 10),
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
                SizedBox(height: 10),
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
