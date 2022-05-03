import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/blocs/authentication_bloc.dart';
import 'package:shuttla/core/mixin/validators.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';
import 'package:shuttla/ui/widgets/error_bottom_sheet.dart';
import 'package:shuttla/ui/widgets/loading_indicator.dart';

class LoginScreen extends StatelessWidget with Validators{
  LoginScreen();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5E9F9),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if(state is AuthAuthenticatingState){
              showDialog(context: context, builder: (context)=> LoadingScreen());
            }

            if (state is AuthErrorState){
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (context) => ErrorBottomSheet(description: state.error.toString()),
              );
            }

            if (state is AuthAuthenticatedState) {
              Navigator.pop(context);
              switch (state.user!.userData.userTypeEnum) {
                case UserType.DRIVER:
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.driverHomeScreen, (route) => false);
                  break;
                case UserType.ADMIN:
                case UserType.PASSENGER:
                default:
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteNames.passengerHomeScreen, (route) => false);
              }
            }
          },
          child: Form(
            key: loginFormKey,
            child: ListView(
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
                Text("Email",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Gap(10),
                BoxTextField(hintText: "abc@xyz.com",
                  controller: emailC,
                  validator: (value) => validateEmail(value!),
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
                Gap(50),
                BoxButton.purple(
                  text: "Login",
                  onPressedWithNotifier: (notifier) {
                    if(!loginFormKey.currentState!.validate()) return;
                    context.read<AuthenticationBloc>()
                        .add(AuthLoginEvent(emailC.text, passwordC.text));
                    // UserType role = UserType.PASSENGER;
                    // if (role == UserType.DRIVER)
                    //   Navigator.pushNamed(context, RouteNames.driverHomeScreen);
                    // else if (role == UserType.PASSENGER)
                    //   Navigator.pushNamed(
                    //       context, RouteNames.passengerHomeScreen);
                    // else
                    //   Navigator.pushNamed(
                    //       context, RouteNames.passengerHomeScreen);
                  },
                ),
                Gap(30),
                Row(
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, RouteNames.userSelectScreen),
                        child: Text(
                          "Create one",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Gap(30),
              ],
            ),
          ),
        ));
  }
}
