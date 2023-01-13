import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Displays Prominent Disclosure for Background Location Permission
///
/// Usage:
///```dart
///ProminentDisclosure.showProminentDisclosure(context, ()=>Navigator.push(Login));
///```
class ProminentDisclosure extends StatelessWidget {
  static late PermissionStatus status;
  static const Permission locationPermission = Permission.location;
  static void showProminentDisclosure(
      BuildContext ctx, VoidCallback onPermissionGranted) async {
    status = await locationPermission.status;
    if (status.isGranted) {
      onPermissionGranted.call();
      return;
    }
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) =>
            ProminentDisclosure(onPermissionGranted: onPermissionGranted)));
  }

  void requestPermission() async {
    status = await locationPermission.request();
    print((await Permission.locationWhenInUse.status).isGranted);
    print((await Permission.location.status).isGranted);
    print((await Permission.locationAlways.status).isGranted);
    if (status.isGranted) {
      onPermissionGranted.call();
    }
  }

  final VoidCallback onPermissionGranted;
  const ProminentDisclosure({Key? key, required this.onPermissionGranted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.black,
                size: 60,
              ),
              Spacer(flex: 1),
              Text(
                "Kobo Transporter collects location data to enable Geo keep track of the location of drivers on trips.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Spacer(flex: 2),
              Image.asset('images/map_illus.png'),
              Spacer(flex: 3),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )),
                  Spacer(),
                  TextButton(
                      onPressed: requestPermission,
                      child: Text("Allow",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
