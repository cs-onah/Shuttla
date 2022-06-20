import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/session_manager.dart';

void routeUserRole(BuildContext context, [AppUser? u]) async{
  AppUser? user = u ?? await SessionManager.getUser();
  if(user == null) {
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (route) => false);
    return;
  }

  switch(user.userData.userTypeEnum){
    case UserType.DRIVER:
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.driverHomeScreen, (route)=> false);
      break;
    case UserType.ADMIN:
    case UserType.PASSENGER:
    default:
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.passengerHomeScreen, (route)=> false);
  }
}