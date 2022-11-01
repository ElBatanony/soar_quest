import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'ui/sq_drawer.dart';
import 'sq_auth.dart';
import 'db/sq_field.dart';
import 'screens/screen.dart';

class SQApp {
  static late String name;
  static late ThemeData theme;
  static SQDrawer? drawer;
  static late List<Screen> navbarScreens;
  static int selectedNavScreen = 0;

  static Future<void> init(
    String name, {
    ThemeData? theme,
    List<SQField<dynamic>>? userDocFields,
    FirebaseOptions? firebaseOptions,
  }) async {
    SQApp.name = name;
    SQApp.theme =
        theme ?? ThemeData(primaryColor: Colors.blue, useMaterial3: true);

    WidgetsFlutterBinding.ensureInitialized();
    if (firebaseOptions != null) {
      await initializeFirebaseApp(firebaseOptions);
      await SQAuth.init(userDocFields: userDocFields);
    }
  }

  static void run(
    List<Screen> screens, {
    SQDrawer? drawer,
    int startingScreen = 0,
  }) {
    SQApp.drawer = drawer;
    SQApp.navbarScreens = screens;
    SQApp.selectedNavScreen = startingScreen;
    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: SQApp.navbarScreens[SQApp.selectedNavScreen]));
  }
}

Future<FirebaseApp> initializeFirebaseApp(FirebaseOptions options) {
  return Firebase.initializeApp(options: options);
}
