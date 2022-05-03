import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/auth_service.dart';
import 'package:shuttla/ui/screens/passenger/passenger_home_screen.dart';
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
    Future.delayed(Duration(seconds: 3), (){
      SizeConfig().init(context);
      Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
    });

    printUserData();
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

  void printUserData() async{
    dynamic u = await AuthService().getCurrentUser();
    print(u.toMap().toString());
  }
}
