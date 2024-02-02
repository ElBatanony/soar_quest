import 'dart:async';

import 'package:flutter/material.dart';

import 'data/sq_analytics.dart';
import 'screens/screen.dart';
import 'ui/drawer.dart';

class SQApp {
  static late String name;
  static SQDrawer? drawer;
  static late List<Screen> navbarScreens;
  static int selectedNavScreen = 0;
  static SQAnalytics? analytics;

  static Future<void> init(
    String name, {
    SQAnalytics? analytics,
  }) async {
    SQApp.name = name;

    WidgetsFlutterBinding.ensureInitialized();

    SQApp.analytics = analytics;
    analytics?.init();
  }

  static void run(
    List<Screen> screens, {
    SQDrawer? drawer,
    int startingScreen = 0,
    ThemeData? themeData,
  }) {
    SQApp.drawer = drawer;
    SQApp.navbarScreens = screens;
    SQApp.selectedNavScreen = startingScreen;

    themeData = themeData;

    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: SQApp.navbarScreens[SQApp.selectedNavScreen].toWidget()));
  }
}
