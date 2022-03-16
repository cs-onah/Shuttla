import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/ui/screens/register_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

enum UserType {DRIVER, PASSENGER, ADMIN}

extension Features on UserType{
  String? getText(){
    switch(this){
      case UserType.ADMIN:
        return "Admin";
      case UserType.DRIVER:
        return "Driver";
      case UserType.PASSENGER:
        return "Passenger";
      default:
        return null;
    }
  }
}

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen();
  @override
  _UserSelectScreenState createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sign up as",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(30),
            SizedBox(
              width: double.infinity,
              child: BoxButton.purple(
                onPressed: ()=> navigate(UserType.PASSENGER),
                text: "Passenger",
                textSize: 20,
              ),
            ),
            Gap(10),
            SizedBox(
              width: double.infinity,
              child: BoxButton.purple(
                onPressed: ()=> navigate(UserType.DRIVER),
                text: "Driver",
                textSize: 20,
              ),
            ),
            Gap(10),
            SizedBox(
              width: double.infinity,
              child: BoxButton.purple(
                onPressed: ()=> navigate(UserType.ADMIN),
                text: "Admin",
                textSize: 20,
              ),
            ),
          ],
        ),
      )
    );
  }

  navigate(UserType type){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen(type)));
  }
}
