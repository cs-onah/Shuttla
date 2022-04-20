import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5E9F9),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthOf(6),
            vertical: 20,
        ),
        children: [
          Gap(SizeConfig.heightOf(20)),
          Text(
              'Log in.',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
              ),
          ),
          const Gap(10),
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(60),
          Text("Email", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Gap(10),
          BoxTextField(hintText: "abc@xyz.com"),
          const Gap(30),
          Text("Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Gap(10),
          BoxTextField(obscureText: true, hintText: "••••••••",),
          Gap(50),
          BoxButton.purple(
              text: "Login",
            onPressed: (){
                String role = "driver";

                if(role == "driver")
                  Navigator.pushNamed(context, RouteNames.driverHomeScreen);
                else if(role == "passenger")
                  Navigator.pushNamed(context, RouteNames.passengerHomeScreen);
                else
                  Navigator.pushNamed(context, RouteNames.passengerHomeScreen);
            },
          ),
          Gap(30),
          Row(
            children: [
              Text("Don't have an account?"),
              TextButton(
                  onPressed: ()=>Navigator.pushNamed(context, RouteNames.userSelectScreen),
                  child: Text("Create one", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
              )
            ],
          ),
          Gap(30),
        ],
      )
    );
  }
}
