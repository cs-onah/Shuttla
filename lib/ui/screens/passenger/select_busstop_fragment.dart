import 'package:flutter/material.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/ui/screens/passenger/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/dragging_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectBusstopFragment extends StatefulWidget {
  final ScrollController controller;
  const SelectBusstopFragment(this.controller);
  @override
  State<SelectBusstopFragment> createState() => _SelectBusstopFragmentState();
}

class _SelectBusstopFragmentState extends State<SelectBusstopFragment> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthOf(6),
          vertical: 10,
        ),
        shrinkWrap: true,
        controller: widget.controller,
        children: [
          DragHandle(),
          SizedBox(height: 10),
          // if (controller.position.maxScrollExtent == controller.offset) Icon(Icons.close),
          Text(
            'Select Busstop',
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
          SizedBox(height: 30),
          for (int i = 0; i < 4; i++)
            BusstopTile(isSelected: i == 0),

          SizedBox(height: 20),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12)),
              ),
              backgroundColor:
              Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              context.read<PassengerHomeBloc>().add(
                  PassengerFetchStationDetailEvent("stationId", "stationName")
              );
              showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12)),
                  ),
                  builder: (context) {
                    return StationDetailScreen("SEET Head", "1");
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Continue",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
