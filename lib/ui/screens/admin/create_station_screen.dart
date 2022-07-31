import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/data_models/shuttla_location.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class CreateStationScreen extends StatefulWidget {
  const CreateStationScreen({Key? key}) : super(key: key);
  @override
  State<CreateStationScreen> createState() => _CreateStationScreenState();
}

class _CreateStationScreenState extends State<CreateStationScreen> with UiKit {
  final stationName = TextEditingController();
  final stationDescription = TextEditingController();
  ShuttlaLocation? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StationCubit, StationState>(listener: (context, state) {
      if (state is SuccessStationState) Navigator.pop(context);
      if (state is ErrorStationState) showToastMessage(context, state.error);
    }, builder: (context, state) {
      final cubit = BlocProvider.of<StationCubit>(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Create Station"),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: () async {
                selectedLocation = await Navigator.of(context).pushNamed(
                  RouteNames.locationSelectScreen,
                );
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.grey[200]),
                child: Column(
                  children: [
                    Icon(Icons.add_location_alt_outlined, size: 60),
                    SizedBox(height: 20),
                    Text("Pick Location"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            BoxTextField(
              hintText: "Station Name",
              controller: stationName,
              validator: (value) =>
                  value!.length < 3 ? "Characters must be more than 3" : null,
            ),
            SizedBox(height: 12),
            BoxTextField(hintText: "Station Description"),
            SizedBox(height: 12),
            BoxButton.rounded(
              text: "Create",
              onPressedWithNotifier: (notifier) async {
                if (selectedLocation == null)
                  showToastMessage(
                    context,
                    "You need to select the station coordinates",
                  );

                notifier.value = true;
                await cubit.createStation(
                  stationName: stationName.text,
                  description: stationDescription.text,
                  latitude: selectedLocation!.latitude!,
                  longitude: selectedLocation!.longitude!,
                );
                notifier.value = false;
              },
            ),
          ],
        ),
      );
    });
  }
}
