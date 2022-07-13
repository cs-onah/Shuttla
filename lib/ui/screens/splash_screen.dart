import 'package:flutter/material.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/global_events.dart';
import 'package:shuttla/ui/size_config/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      SizeConfig().init(context);
      startListeners();
      routeUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD3FFFF),
      body: Center(
        child: SizedBox(
          height: 200,
        child: Image.asset("images/logo_gif.gif"),
        ),
      )
    );
  }

  void routeUser() async{
    SessionManager.init();
    RouteNames.routeUserRole(context);
  }

  void startListeners() {
    eventBus.on<LogOutEvent>().listen((event) {
      print("Logged out because: $event");
      Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.loginScreen, (route) => false,
      );
    });
  }

}
