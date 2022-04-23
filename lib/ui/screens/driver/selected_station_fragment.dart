import 'package:flutter/material.dart';
import 'package:shuttla/ui/screens/passenger/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class SelectedStationFragment extends StatelessWidget {
  const SelectedStationFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.widthOf(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.adjust, size: 30, color: Colors.grey[600]),
                SizedBox(width: 15),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: 'You have selected \n',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: "SEET HEAD",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BoxButton.rounded(
                    text: "Cancel",
                    backgroundColor: Colors.grey[500],
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 140,
                    child: BoxButton.rounded(
                      text: "Continue",
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> StationDetailScreen("stationName", "stationId"))
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
