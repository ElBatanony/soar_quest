import 'dart:async';

import 'package:flutter/material.dart';

import 'data/sq_analytics.dart';
import 'data/sq_field.dart';
import 'features/dark_mode_setting.dart';
import 'screens/screen.dart';
import 'sq_auth.dart';
import 'ui/drawer.dart';

class SQApp {
  static late String name;
  static late ThemeData theme;
  static SQDrawer? drawer;
  static late List<Screen> navbarScreens;
  static int selectedNavScreen = 0;
  static SQAnalytics? analytics;

  static Future<void> init(
    String name, {
    ThemeData? theme,
    List<SQField<dynamic>>? userDocFields,
    List<AuthMethod>? authMethods,
    SQAnalytics? analytics,
  }) async {
    SQApp.name = name;
    SQApp.theme = theme ?? ThemeData.light(useMaterial3: true);

    WidgetsFlutterBinding.ensureInitialized();

    SQAuth.offline = true;

    SQApp.analytics = analytics;
    analytics?.init();

    await SQAuth.init(userDocFields: userDocFields, methods: authMethods);
  }

  static void run(
    List<Screen> screens, {
    SQDrawer? drawer,
    int startingScreen = 0,
  }) {
    SQApp.drawer = drawer;
    SQApp.navbarScreens = screens;
    SQApp.selectedNavScreen = startingScreen;

    final user = SQAuth.user;
    if (user != null) unawaited(SQApp.analytics?.setUserId(user.userId));

    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: SQApp.theme,
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: SQDarkMode.themeMode,
        home: SQApp.navbarScreens[SQApp.selectedNavScreen].toWidget()));
  }
}
