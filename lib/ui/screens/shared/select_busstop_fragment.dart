import 'package:flutter/material.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/ui/screens/shared/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/dragging_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectStationFragment extends StatefulWidget {
  final ScrollController controller;
  final String? title, description;
  final Function(dynamic)? itemSelectAction;
  const SelectStationFragment(this.controller,
      {this.title, this.description, this.itemSelectAction});
  @override
  State<SelectStationFragment> createState() => _SelectStationFragmentState();
}

class _SelectStationFragmentState extends State<SelectStationFragment> {
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
            '${widget.title ?? "Select Station"}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${widget.description ?? ""}',
            style: TextStyle(fontSize: 14),
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
                prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(height: 10),
          for (int i = 0; i < 4; i++)
            BusstopTile(onClicked: widget.itemSelectAction),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
