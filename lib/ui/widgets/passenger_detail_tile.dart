import 'package:flutter/material.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/user_data.dart';

class PassengerListTile extends StatelessWidget {
  final List<UserData> passengers;

  const PassengerListTile(this.passengers);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: passengers.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver(s) Approaching",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...passengers.map(
                  (e) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          foregroundImage: AssetImage(e.imageResourcePath),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "${e.nickname}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                        'Empty Station',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No passenger is currently waiting at station',
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
