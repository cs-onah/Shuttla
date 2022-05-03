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

  AppUser? _appuser;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _auth = auth ?? FirebaseAuth.instance;
    _users = _firestore.collection(CollectionName.USERS);
  }

  registerAdmin(String nickName, String email, String password) {}

  Future<AppUser?> loginUser(String email, String password) async{
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentSnapshot snapshot = await _users.doc(cred.user!.uid).get();
    _appuser = AppUser.fromMap(snapshot.data()!);
    return _appuser;
  }

  Future<AppUser?> registerPassenger(String nickName, String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _appuser = AppUser(
      userData: UserData(
        email: email,
        imageResource: _generateProfileRes,
        nickname: nickName,
        userId: cred.user?.uid ?? "",
        userType: UserType.PASSENGER.getString,
      ),
    );
    await _users.doc(_appuser!.userData.userId).set(_appuser!.toMap());
    return _appuser;
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

    _appuser = AppUser(
      userData: UserData(
        email: email,
        imageResource: _generateProfileRes,
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
    _users.doc(_appuser!.userData.userId).set(_appuser!.toMap());
    return _appuser;
  }

  Future<bool> logOut() async{
    await _auth.signOut();
    _appuser = null;
    return true;
  }

  Future<AppUser?> getCurrentUser() async{
    if(_appuser != null) return _appuser;

    String? uid = _auth.currentUser?.uid;
    if(uid != null){
      DocumentSnapshot snapshot = await _users.doc(uid).get();
      _appuser = AppUser.fromMap(snapshot.data()!);
      return _appuser;
    }
  }

  String get _generateProfileRes => (Random().nextInt(5) + 1).toString();
}
