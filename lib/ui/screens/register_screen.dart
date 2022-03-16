import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/ui/screens/select_user_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  final UserType? type;
  const RegisterScreen([UserType? userType]) : type = userType?? UserType.PASSENGER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthOf(6),
            vertical: 20,
          ),
          children: [
            Row(
              children: [
                BackButton(onPressed: ()=> Navigator.pop(context)),
              ],
            ),
            Gap(SizeConfig.heightOf(5)),
            Text(
              'Register.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Text(
              'Create ${type!.getText()} Account!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(40),
            Text("Email", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "abc@xyz.com"),
            const Gap(30),
            Text("Nick Name", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "Jay"),
            const Gap(30),
            Text("Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(obscureText: true, hintText: "••••••••",),
            const Gap(30),
            Text("Repeat Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(obscureText: true, hintText: "••••••••",),
            Gap(50),
            BoxButton.purple(text: "Register"),
            Gap(30),
            Row(
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: ()=>Navigator.pushNamed(context, RouteNames.userSelectScreen),
                    child: Text("Sign in", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                )
              ],
            ),
            Gap(30),
          ],
        ),
      ),
    );
  }
}
