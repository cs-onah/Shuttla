import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/data_models/shuttla_location.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/location_service.dart';
import 'package:shuttla/ui/screens/shared/location_select_screen.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

/// Create/Edits a station
///
/// is used to edit if [station] is provided.
class CreateStationScreen extends StatefulWidget {
  final Station? station;
  const CreateStationScreen({Key? key, this.station}) : super(key: key);
  @override
  State<CreateStationScreen> createState() => _CreateStationScreenState();
}

class _CreateStationScreenState extends State<CreateStationScreen> with UiKit {
  final stationName = TextEditingController();
  final stationDescription = TextEditingController();
  ShuttlaLocation? selectedLocation;

  bool get isEdit => widget.station != null;

  @override
  void initState() {
    //Initialize values if isEdit
    if (isEdit) {
      Station s = widget.station!;
      stationName.text = s.stationName;
      stationDescription.text = s.description ?? "";
      selectedLocation = ShuttlaLocation(
        latitude: s.coordinates[0],
        longitude: s.coordinates[1],
        address: "",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StationCubit, StationState>(listener: (context, state) {
      if (state is SuccessStationState) Navigator.pop(context);
      if (state is ErrorStationState) showToastMessage(context, state.error);
    }, builder: (context, state) {
      final cubit = BlocProvider.of<StationCubit>(context);
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Create Station"),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSelectScreen(),
                  ),
                );
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: selectedLocation != null
                      ? GoogleMap(
                          zoomControlsEnabled: false,
                          markers: {
                            Marker(
                              markerId: MarkerId("station"),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed,
                              ),
                              position: LatLng(
                                selectedLocation!.latitude!,
                                selectedLocation!.longitude!,
                              ),
                            )
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              selectedLocation!.latitude!,
                              selectedLocation!.longitude!,
                            ),
                            zoom: 16,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_location_alt_outlined, size: 60),
                            SizedBox(height: 20),
                            Text("Pick Location"),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 30),
            BoxTextField(
              hintText: "Station Name",
              controller: stationName,
              validator: (value) =>
                  value!.length < 3 ? "Characters must be more than 3" : null,
            ),
            SizedBox(height: 20),
            BoxTextField(hintText: "Station Description"),
            SizedBox(height: 30),
            BoxButton.rounded(
              text: isEdit ? "Edit" : "Create",
              onPressedWithNotifier: (notifier) async {
                if (selectedLocation == null)
                  showToastMessage(
                    context,
                    "You need to select the station coordinates",
                  );

                notifier.value = true;
                if (isEdit)
                  await cubit.editStation(
                    widget.station!.copyWith(
                      stationName: stationName.text,
                      description: stationDescription.text,
                      coordinates: [
                        selectedLocation!.latitude!,
                        selectedLocation!.longitude!,
                      ],
                    ),
                  );
                else
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
