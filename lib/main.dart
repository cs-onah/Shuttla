import 'package:flutter/material.dart';
import 'package:shuttla/app.dart';

import 'locator.dart';

void main() {
  //Register services
  setupLocator();
  runApp(Shuttla());
}
