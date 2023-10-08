import 'dart:async';

import 'package:flutter/material.dart';

import '../mini_apps.dart';
import 'data/sq_analytics.dart';
import 'data/sq_field.dart';
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
    List<SQField<dynamic>>? userDocFields,
    SQAnalytics? analytics,
  }) async {
    SQApp.name = name;

    MiniApp.init();

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

    MiniApp.ready();
    MiniApp.expand();

    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: SQApp.navbarScreens[SQApp.selectedNavScreen].toWidget()));
  }
}
