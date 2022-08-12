import 'package:flutter/material.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';

class BusstopTile extends StatelessWidget with UiKit {
  final Function(Station)? onClicked;
  final Station station;
  final bool isSuggested;
  const BusstopTile({
    Key? key,
    this.onClicked,
    required this.station,
    this.isSuggested = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          if (station.isClosed) {
            showToastMessage(
              context,
              "This station is closed and cant be accessed.",
              duration: Duration(seconds: 1),
            );
            return;
          }
          if (onClicked != null) onClicked!(station);
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined,
                    size: 30, color: Colors.grey[600]),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        station.stationName,
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${station.distanceFromDeviceString ?? '-- meters'} '
                        'away from you',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${station.waitingPassengers.length} passengers waiting',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                if (isSuggested) SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isSuggested)
                      Text(
                        "Suggested",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 15),
                    if (station.isClosed)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          "CLOSED",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
