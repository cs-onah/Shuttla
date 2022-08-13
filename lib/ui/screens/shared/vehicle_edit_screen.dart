import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/core/services/auth_service.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/utilities/validators.dart';
import 'package:shuttla/ui/screens/shared/ui_kit.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class VehicleEditScreen extends StatefulWidget {
  const VehicleEditScreen({Key? key}) : super(key: key);

  @override
  State<VehicleEditScreen> createState() => _VehicleEditScreenState();
}

class _VehicleEditScreenState extends State<VehicleEditScreen> with Validators, UiKit {
  final plateNumberC = TextEditingController();
  final carManufacturerC = TextEditingController();
  final carModelC = TextEditingController();
  final carColorC = TextEditingController();
  final vehicleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text("Update Vehicle", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
        children: [
          Gap(30),
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
          SizedBox(
            width: double.infinity,
            child: BoxButton.purple(
              text: "Save",
              onPressedWithNotifier: updateVehicle,
            ),
          ),
          Gap(30),
        ],
      ),
    );
  }

  void updateVehicle(ValueNotifier notifier) async {
    if(!vehicleFormKey.currentState!.validate()) return;
    notifier.value = true;
    final authService = AuthService();
    try {
      bool result =
      await authService.updateUserProfile(SessionManager.user!.copyWith(
          driverData: SessionManager.user!.driverData!.copyWith(
            carColor: carColorC.text,
            carModel: carModelC.text,
            carManufacturer: carManufacturerC.text,
            plateNumber: plateNumberC.text,
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
      showToastMessage(context, '$e');
    } finally {
      notifier.value = false;
    }
  }
}
