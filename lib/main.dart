import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shuttla/app.dart';

import 'locator.dart';

void main() async{
  //Register services
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "secret_key.env");
  setupLocator();
  await Firebase.initializeApp();
  runApp(Shuttla());
}
