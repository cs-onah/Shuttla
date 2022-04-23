import 'package:flutter/material.dart';

class BusstopTile extends StatelessWidget {
  final Function(dynamic)? onClicked;
  final dynamic stationDetails;
  const BusstopTile({
    Key? key, this.onClicked, this.stationDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          if(onClicked != null) onClicked!(stationDetails);
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 30, color: Colors.grey[600]),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SEET Head Station',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '40m away from you',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
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
