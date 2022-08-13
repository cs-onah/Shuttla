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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Validators, UiKit {
  List<int> profileImages = [1, 2, 3, 4, 5, 6];
  final emailC = TextEditingController();
  final nickNameC = TextEditingController();
  var profileImgController = PageController(viewportFraction: .45);
  int selectedImageIndex = 0;
  final profileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    //init values
    if (SessionManager.user != null) {
      AppUser u = SessionManager.user!;
      emailC.text = u.userData.email;
      nickNameC.text = u.userData.nickname!;
      selectedImageIndex = profileImages.indexWhere(
        (element) => element.toString() == u.userData.imageResource,
      );
      profileImgController = PageController(
        viewportFraction: .45,
        initialPage: selectedImageIndex,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => SessionManager.logout(),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Form(
        key: profileFormKey,
        child: ListView(
          children: [
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 8)),
                  ),
                  SizedBox(
                    height: 140,
                    child: PageView(
                      controller: profileImgController,
                      onPageChanged: (val) {
                        setState(() {
                          selectedImageIndex = val;
                        });
                      },
                      children: [
                        for (int i = 0; i < profileImages.length; i++)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: selectedImageIndex == i ? 60 : 40,
                                foregroundImage: AssetImage(
                                    'images/Avatar-${profileImages[i]}.png'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  BoxTextField(
                    readOnly: true,
                    hintText: "abc@xyz.com",
                    controller: emailC,
                    validator: (value) => validateEmail(value!),
                  ),
                  const Gap(30),
                  Text("Nick Name",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Gap(10),
                  BoxTextField(
                    hintText: "Jay",
                    controller: nickNameC,
                    validator: (value) => validateName(value!),
                  ),
                  const Gap(30),
                  SizedBox(
                    width: double.infinity,
                    child: BoxButton.purple(
                      text: "Save",
                      onPressedWithNotifier: updateProfile,
                    ),
                  ),
                  Gap(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateProfile(ValueNotifier notifier) async {
    if(!profileFormKey.currentState!.validate()) return;
    notifier.value = true;
    final authService = AuthService();
    try {
      bool result =
          await authService.updateUserProfile(SessionManager.user!.copyWith(
              userData: SessionManager.user!.userData.copyWith(
        nickname: nickNameC.text,
        email: emailC.text,
        imageResource: profileImages[selectedImageIndex].toString(),
      )));
      if (result) {
        Navigator.pop(context);
        showToastMessage(
          context,
          "Profile Updated",
          success: true,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      notifier.value = false;
      showToastMessage(context, '$e');
    }
  }
}
