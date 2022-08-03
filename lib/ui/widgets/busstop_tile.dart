import 'package:flutter/material.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/core/utilities/utility.dart';

class BusstopTile extends StatelessWidget {
  final Function(Station)? onClicked;
  final Station station;
  final bool isSuggested;
  const BusstopTile({
    Key? key,
    this.onClicked,
    required this.station, this.isSuggested = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
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
                    ],
                  ),
                ),
                if (isSuggested) SizedBox(width: 5),
                if(isSuggested) Text(
                  "Suggested",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
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
