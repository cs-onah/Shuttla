import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/ui/screens/onboarding/register_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen();
  @override
  _UserSelectScreenState createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(onPressed: ()=> Navigator.pop(context), color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
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
          ],
        ),
      )
    );
  }

  navigate(UserType type){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen(type)));
  }
}
