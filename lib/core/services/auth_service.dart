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

  Future<AppUser> loginUser(String email, String password) async{
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentSnapshot snapshot = await _users.doc(cred.user!.uid).get();
    AppUser user = AppUser.fromMap(snapshot.data()!);
    return user;
  }

  Future<AppUser> registerPassenger(String nickName, String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final newUser = AppUser(
      userData: UserData(
        email: email,
        imageResource: generateProfileRes,
        nickname: nickName,
        userId: cred.user?.uid ?? "",
        userType: UserType.PASSENGER.getString,
      ),
    );
    print(cred.user?.uid);
    await _users.doc(newUser.userData.userId).set(newUser.toMap());
    return newUser;
  }

  Future<AppUser> registerDriver({
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

    final newUser = AppUser(
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
    );
    _users.doc(newUser.userData.userId).set(newUser.toMap());
    return newUser;
  }

  Future<bool> logOut() async{
    await _auth.signOut();
    return true;
  }

  String get generateProfileRes => (Random().nextInt(5) + 1).toString();
}
