import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/auth_service.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/validators.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with Validators, UiKit {
  final oldPassC = TextEditingController();
  final newPassC = TextEditingController();
  final passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text("Change Password", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Form(
        key: passwordFormKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
          children: [
            SizedBox(height: 30),
            Text("Old Password",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              obscureText: true,
              hintText: "••••••••",
              controller: oldPassC,
              validator: (value) => validatePassword(value!),
            ),
            SizedBox(height: 30),
            Text("New Password",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const Gap(10),
            BoxTextField(
              obscureText: true,
              hintText: "••••••••",
              controller: newPassC,
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
              value == newPassC.text ? null : "Does not match",
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: BoxButton.purple(
                text: "Save",
                onPressedWithNotifier: changePassword,
              ),
            ),
            Gap(30),
          ],
        ),
      ),
    );
  }

  void changePassword(ValueNotifier notifier) async {
    if(!passwordFormKey.currentState!.validate()) return;
    notifier.value = true;
    final authService = AuthService();
    try {
      bool result =
      await authService.changePassword(oldPassC.text, newPassC.text);
      if (result) {
        Navigator.pop(context);
        showToastMessage(
          context,
          "Password Updated",
          success: true,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      showToastMessage(context, '$e');
    } finally {
      notifier.value = false;
    }
  }
}
