import 'package:flutter/material.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    eventBus.on<LogOutEvent>().listen((event) {
      print("Logged out because: ${event.reason}");
      Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.loginScreen, (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stations"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => SessionManager.logout(),
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
