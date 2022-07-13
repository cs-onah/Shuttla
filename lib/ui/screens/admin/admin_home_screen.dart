import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/services/session_manager.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

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
