import './Screens/addMedicationScreen.dart';
import './Screens/homePageScreen.dart';
import './Screens/pillBox.dart';
import './Screens/splashScreen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (ctx) => SplashScreen(),
  HomePageScreen.routeName: (ctx) => HomePageScreen(),
  AddMedicationScreen.routeName: (ctx) => AddMedicationScreen(),
  PillBoxScreen.routeName: (ctx) => PillBoxScreen(),
};
