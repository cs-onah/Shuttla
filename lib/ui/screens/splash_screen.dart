import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/ui/screens/passenger_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
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
}
