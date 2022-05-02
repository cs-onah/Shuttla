import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  late FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  registerAdmin(String nickName, String email, String password) {

  }

  registerPassenger(String nickName, String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );

    cred.user?.updateProfile(
      displayName: nickName,
      photoURL: generateProfileRes,
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

    cred.user?.updateProfile(
      displayName: nickName,
      photoURL: generateProfileRes,
    );
  }

  String get generateProfileRes => (Random().nextInt(5) + 1).toString();

}
