import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/viewmodels/home_viewmodel.dart';
import 'package:shuttla/ui/screens/shared/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class SelectedStationFragment extends StatelessWidget {
  final Station station;
  const SelectedStationFragment(this.station);

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomeViewmodel>();
    final bloc = BlocProvider.of<DriverHomeBloc>(context);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'You have selected \n',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: "${station.stationName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                      SizedBox(height: 5),
                      Text("${station.waitingPassengers.length} passengers waiting"),
                      SizedBox(height: 10),
                      Text(
                        '* ${station.distanceFromDeviceString} from your location',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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
                      backgroundColor: Theme.of(context).primaryColorDark,
                      onPressed: () {
                        homeModel.removeLocationMarkers();
                        homeModel.startLocationStream();
                        bloc.add(DriverFetchStationDetailEvent(station));
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          builder: (context) => StationDetailScreen(station, userRole: UserType.DRIVER),
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
