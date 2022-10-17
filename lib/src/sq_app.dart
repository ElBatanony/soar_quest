import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'auth/sq_auth.dart';
import 'db/sq_field.dart';
import 'screens/screen.dart';

class SQApp {
  static late String name;
  static late ThemeData theme;
  static SQDrawer? drawer;
  static SQNavBar? navbar;
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

  static void run(SQNavBar navbar, {SQDrawer? drawer}) {
    SQApp.drawer = drawer;
    SQApp.navbar = navbar;
    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: navbar.screens[0]));
  }
}

Future<FirebaseApp> initializeFirebaseApp(FirebaseOptions options) {
  return Firebase.initializeApp(options: options);
}
