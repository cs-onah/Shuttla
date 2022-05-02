import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/driver_data.dart';
import 'package:shuttla/core/data_models/user_data.dart';

class AuthService {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late CollectionReference _users;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _auth = auth ?? FirebaseAuth.instance;
    _users = _firestore.collection(CollectionName.USERS);
  }

  registerAdmin(String nickName, String email, String password) {}

  registerPassenger(String nickName, String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _users.add(
      AppUser(
        userData: UserData(
          email: email,
          imageResource: generateProfileRes,
          nickname: nickName,
          userId: cred.user?.uid ?? "",
          userType: UserType.PASSENGER.getString,
        ),
      ).toMap(),
    );
  }

  registerDriver({
    required String nickName,
    required String email,
    required String password,
    required String plateNumber,
    required String carManufacturer,
    required String carModel,
    required String carColor,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _users.add(
      AppUser(
        userData: UserData(
          email: email,
          imageResource: generateProfileRes,
          nickname: nickName,
          userId: cred.user?.uid ?? "",
          userType: UserType.PASSENGER.getString,
        ),
        driverData: DriverData(
          plateNumber: plateNumber,
          carManufacturer: carManufacturer,
          carModel: carModel,
          carColor: carColor,
        ),
      ).toMap(),
    );
  }

  String get generateProfileRes => (Random().nextInt(5) + 1).toString();
}
