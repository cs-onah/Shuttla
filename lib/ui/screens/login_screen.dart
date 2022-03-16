import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/ui/size_config/size_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthOf(6),
            vertical: 20,
        ),
        children: [
          const Gap(20),
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
          const Gap(30),
          Text("E-mail", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
            ),
          ),
          Gap(50),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
              onPressed: (){},
              child: Text("Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          )

        ],
      )
    );
  }
}
