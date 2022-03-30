import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/ui/screens/select_user_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  final UserType? type;
  const RegisterScreen([UserType? userType])
      : type = userType ?? UserType.PASSENGER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthOf(6),
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BackButton(onPressed: () => Navigator.pop(context)),
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
                  const Gap(20),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (type) {
                    case UserType.PASSENGER:
                      return PassengerRegistrationFragment();
                    case UserType.DRIVER:
                      return DriverRegistrationFragment();
                    case UserType.ADMIN:
                      return AdminRegistrationFragment();
                    default:
                      return PassengerRegistrationFragment();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PassengerRegistrationFragment extends StatelessWidget {
  const PassengerRegistrationFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
      children: [
        Text("Email",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Gap(10),
        BoxTextField(hintText: "abc@xyz.com"),
        const Gap(30),
        Text("Nick Name",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Gap(10),
        BoxTextField(hintText: "Jay"),
        const Gap(30),
        Text("Password",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Gap(10),
        BoxTextField(
          obscureText: true,
          hintText: "••••••••",
        ),
        const Gap(30),
        Text("Repeat Password",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Gap(10),
        BoxTextField(
          obscureText: true,
          hintText: "••••••••",
        ),
        Gap(40),
        SizedBox(
          width: double.infinity,
          child: BoxButton.purple(text: "Register"),
        ),
        Gap(30),
        Row(
          children: [
            Text("Already have an account?"),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.userSelectScreen),
              child: Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Gap(30),
      ],
    );
  }
}

class DriverRegistrationFragment extends StatelessWidget {
  DriverRegistrationFragment({Key? key}) : super(key: key);

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        //Personal Info section
        ListView(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
          children: [
            Text(
              'Personal Data',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Gap(10),
            Divider(height: 0, color: Colors.grey),
            Gap(20),
            Text("Email",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "abc@xyz.com"),
            const Gap(30),
            Text("Nick Name",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "Jay"),
            const Gap(30),
            Text("Password",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              obscureText: true,
              hintText: "••••••••",
            ),
            const Gap(30),
            Text("Repeat Password",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              obscureText: true,
              hintText: "••••••••",
            ),
            Gap(40),
            BoxButton.purple(
              text: "Next",
              onPressed: () => controller.animateToPage(
                1,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              ),
            ),
            Gap(30),
          ],
        ),

        //Driver Info section
        ListView(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
          children: [
            Text(
              'Vehicle Data',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Gap(10),
            Divider(height: 0, color: Colors.grey),
            Gap(20),
            Text("Plate Number",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "ABC-XYZ"),
            const Gap(30),
            Text("Car Manufacturer",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(hintText: "Toyota"),
            const Gap(30),
            Text("Car Model",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              hintText: "E-350",
            ),
            const Gap(30),
            Text("Color",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              obscureText: true,
              hintText: "Red",
            ),
            Gap(40),
            BoxButton.purple(text: "Register"),
            Gap(30),
            Row(
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.loginScreen),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Gap(30),
          ],
        ),
      ],
    );
  }
}

class AdminRegistrationFragment extends StatelessWidget {
  const AdminRegistrationFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
