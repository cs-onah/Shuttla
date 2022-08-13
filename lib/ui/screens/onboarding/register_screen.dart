import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/authentication_bloc.dart';
import 'package:shuttla/core/utilities/validators.dart';
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
                    'Create ${type!.getString} Account!',
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

class PassengerRegistrationFragment extends StatelessWidget with Validators {
  PassengerRegistrationFragment({Key? key}) : super(key: key);
  final emailC = TextEditingController();
  final nickNameC = TextEditingController();
  final passwordC = TextEditingController();
  final passengerRegisterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: passengerRegisterFormKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
        children: [
          Text(
            "Email",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Gap(10),
          BoxTextField(
            hintText: "abc@xyz.com",
            controller: emailC,
            validator: (value) => validateEmail(value!),
          ),
          const Gap(30),
          Text("Nick Name",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Gap(10),
          BoxTextField(
            hintText: "Jay",
            controller: nickNameC,
            validator: (value) => validateName(value!),
          ),
          const Gap(30),
          Text("Password",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Gap(10),
          BoxTextField(
            obscureText: true,
            hintText: "••••••••",
            controller: passwordC,
            validator: (value) => validatePassword(value!),
          ),
          const Gap(30),
          Text("Repeat Password",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Gap(10),
          BoxTextField(
            obscureText: true,
            hintText: "••••••••",
            validator: (value) =>
                value == passwordC.text ? null : "Does not match",
          ),
          Gap(40),
          SizedBox(
            width: double.infinity,
            child: BoxButton.purple(
              text: "Register",
              onPressed: () {
                if (!passengerRegisterFormKey.currentState!.validate()) return;
                context.read<AuthenticationBloc>().add(AuthPassengerRegister(
                    nickNameC.text, emailC.text, passwordC.text));
              },
            ),
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
      ),
    );
  }
}

class DriverRegistrationFragment extends StatelessWidget with Validators {
  DriverRegistrationFragment({Key? key}) : super(key: key);
  final controller = PageController();

  final emailC = TextEditingController();
  final nickNameC = TextEditingController();
  final passwordC = TextEditingController();
  final plateNumberC = TextEditingController();
  final carManufacturerC = TextEditingController();
  final carModelC = TextEditingController();
  final carColorC = TextEditingController();
  final driverRegisterFormKeyOne = GlobalKey<FormState>();
  final driverRegisterFormKeyTwo = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        //Personal Info section
        Form(
          key: driverRegisterFormKeyOne,
          child: ListView(
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
              BoxTextField(
                hintText: "abc@xyz.com",
                controller: emailC,
                validator: (value) => validateEmail(value!),
              ),
              const Gap(30),
              Text("Nick Name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Gap(10),
              BoxTextField(
                hintText: "Jay",
                controller: nickNameC,
                validator: (value) => validateName(value!),
              ),
              const Gap(30),
              Text("Password",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Gap(10),
              BoxTextField(
                obscureText: true,
                hintText: "••••••••",
                controller: passwordC,
                validator: (value) => validatePassword(value!),
              ),
              const Gap(30),
              Text("Repeat Password",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              const Gap(10),
              BoxTextField(
                obscureText: true,
                hintText: "••••••••",
                validator: (value) =>
                    value == passwordC.text ? null : "Does not match",
              ),
              Gap(40),
              BoxButton.purple(
                text: "Next",
                onPressed: () {
                  if(!driverRegisterFormKeyOne.currentState!.validate()) return;
                  controller.animateToPage(
                  1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
                },
              ),
              Gap(30),
            ],
          ),
        ),

        //Driver Info section
        Form(
          key: driverRegisterFormKeyTwo,
          child: ListView(
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
              BoxTextField(
                hintText: "ABC-XYZ",
                controller: plateNumberC,
                validator: (value) => validateName(value!),
              ),
              const Gap(30),
              Text("Car Manufacturer",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Gap(10),
              BoxTextField(
                hintText: "Toyota",
                controller: carManufacturerC,
                validator: (value) => validateName(value!),
              ),
              const Gap(30),
              Text("Car Model",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Gap(10),
              BoxTextField(
                hintText: "E-350",
                controller: carModelC,
                validator: (value) => validateName(value!),
              ),
              const Gap(30),
              Text("Color",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Gap(10),
              BoxTextField(
                hintText: "Red",
                controller: carColorC,
                validator: (value) => validateName(value!),
              ),
              Gap(40),
              BoxButton.purple(
                text: "Register",
                onPressedWithNotifier: (notifier) {
                  if(!driverRegisterFormKeyTwo.currentState!.validate()) return;
                  notifier.value = true;
                  final bloc = context.read<AuthenticationBloc>();
                  bloc.add(AuthDriverRegister(
                    email: emailC.text,
                    password: passwordC.text,
                    plateNumber: plateNumberC.text,
                    carManufacturer: carManufacturerC.text,
                    carModel: carModelC.text,
                    carColor: carColorC.text,
                    nickName: nickNameC.text,
                  ));
                  notifier.value = false;
                },
              ),
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
