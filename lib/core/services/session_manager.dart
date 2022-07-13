import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shuttla/app.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/utilities/global_events.dart';

class SessionManager {
  static late FirebaseAuth _firebaseAuth;
  static late FirebaseFirestore _firestore;
  static late CollectionReference _userCollection;
  static void init(){
    //Initialize data
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _userCollection = _firestore.collection(CollectionName.USERS);
  }

  static AppUser? _user;
  static AppUser? get user => _user;
  static setUser(AppUser newUser)=> _user = newUser;

  static Future<AppUser?> getUser() async{
    User? u = _firebaseAuth.currentUser;
    if(u != null){
      DocumentSnapshot snapshot = await _userCollection.doc(u.uid).get();
      _user = AppUser.fromMap(snapshot.data()!);
    }
    return _user;
  }

  static Future logout() async {
    await _firebaseAuth.signOut();
    eventBus.fire(LogOutEvent("Logout button clicked"));
    _user = null;
  }


}