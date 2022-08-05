import 'package:flutter/material.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/ui/screens/shared/station_detail_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/busstop_tile.dart';
import 'package:shuttla/ui/widgets/dragging_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectStationFragment extends StatefulWidget {
  final ScrollController controller;
  final String? title, description;
  final Function(Station)? itemSelectAction;
  const SelectStationFragment(this.controller,
      {this.title, this.description, this.itemSelectAction});
  @override
  State<SelectStationFragment> createState() => _SelectStationFragmentState();
}

class _SelectStationFragmentState extends State<SelectStationFragment> {
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<StationCubit>().getStations(showLoader: true);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StationCubit>(context);
    return Card(
      elevation: 30,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: RefreshIndicator(
        onRefresh: () async => await bloc.getStations(),
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
            SizedBox(height: 20),
            TextFormField(
              controller: searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Search Station",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search)),
            ),
            SizedBox(height: 10),
            BlocBuilder<StationCubit, StationState>(builder: (context, state) {
              if (state is LoadingStationState)
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(child: CircularProgressIndicator()),
                );

              if (bloc.stations.isNotEmpty)
                return Column(
                  children: [
                    ...bloc.stations
                        .where((element) => stationFilter(element))
                        .map(
                          (e) => BusstopTile(
                            onClicked: widget.itemSelectAction,
                            station: e,
                            isSuggested: bloc.suggestedStations.contains(e),
                          ),
                        ),
                    // SizedBox(height: 20),
                  ],
                );

              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No Station Found!"),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () => bloc.getStations(), child: Text("Retry")),
                  ],
                )),
              );
            }),
          ],
        ),
      ),
    );
  }

  bool stationFilter(Station station) {
    return station.stationName.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ) ||
        (station.description?.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ??
            false);
  }
}
