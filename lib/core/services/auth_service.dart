import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/driver_data.dart';
import 'package:shuttla/core/data_models/user_data.dart';
import 'package:shuttla/core/services/session_manager.dart';

class AuthService {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late CollectionReference _userCollection;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _auth = auth ?? FirebaseAuth.instance;
    _userCollection = _firestore.collection(CollectionName.USERS);
  }

  registerAdmin(String nickName, String email, String password) {}

  Future<AppUser?> loginUser(String email, String password) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentSnapshot snapshot = await _userCollection.doc(cred.user!.uid).get();
    AppUser appUser = AppUser.fromMap(snapshot.data()!);
    SessionManager.setUser(appUser);
    return appUser;
  }

  Future<AppUser?> registerPassenger(
      String nickName, String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    AppUser appUser = AppUser(
      userData: UserData(
        email: email,
        imageResource: _generateProfileRes,
        nickname: nickName,
        userId: cred.user?.uid ?? "",
        userType: UserType.PASSENGER.getString,
      ),
    );
    await _userCollection.doc(appUser.userData.userId).set(appUser.toMap());
    SessionManager.setUser(appUser);
    return appUser;
  }

  Future<bool> updateDriver(AppUser updatedDriver) async {
    await _userCollection
        .doc(updatedDriver.userData.userId)
        .update(updatedDriver.toMap());
    return true;
  }

  Future<bool> updateUserProfile(AppUser user) async {
    await _userCollection.doc(user.userData.userId).update(user.toMap());
    SessionManager.setUser(user);
    return true;
  }

  Future<AppUser?> registerDriver({
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

    AppUser appUser = AppUser(
      userData: UserData(
        email: email,
        imageResource: _generateProfileRes,
        nickname: nickName,
        userId: cred.user?.uid ?? "",
        userType: UserType.DRIVER.getString,
      ),
      driverData: DriverData(
        plateNumber: plateNumber,
        carManufacturer: carManufacturer,
        carModel: carModel,
        carColor: carColor,
      ),
    );
    _userCollection.doc(appUser.userData.userId).set(appUser.toMap());
    SessionManager.setUser(appUser);
    return appUser;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    bool success = false;
    var user = FirebaseAuth.instance.currentUser!;
    final cred =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);
    UserCredential? userCredential =
        await _auth.currentUser?.reauthenticateWithCredential(cred);
    print(userCredential);
    if(userCredential?.user != null){
      await user.reauthenticateWithCredential(cred).then((value) async =>
      await user.updatePassword(newPassword).then((value) => success = true));
    }
    return success;
  }

  Future<bool> logOut() async {
    await SessionManager.logout();
    return true;
  }

  Future<AppUser?> getCurrentUser() async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot snapshot = await _userCollection.doc(uid).get();
      AppUser user = AppUser.fromMap(snapshot.data()!);
      return user;
    }
  }

  String get _generateProfileRes => (Random().nextInt(5) + 1).toString();
}
