import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import '../auth/firebase_auth_manager.dart';
import '../db/fields/sq_string_field.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../screens/screen.dart';
import '../auth/auth_manager.dart';

class App {
  String name;
  late ThemeData theme;

  late SQAuthManager authManager;

  static SQAuthManager auth = instance.authManager;
  static String get userId => auth.user.userId;
  static SQDoc get userDoc => auth.user.userDoc;

  late List<SQField> userDocFields;
  List<SQField> publicProfileFields;

  static late SQCollection usersCollection;

  FirebaseOptions firebaseOptions;

  static late App instance;

  App(
    this.name, {
    ThemeData? theme,
    SQAuthManager? authManager,
    List<SQField>? userDocFields,
    this.publicProfileFields = const [],
    required this.firebaseOptions,
  }) {
    this.theme =
        theme ?? ThemeData(primaryColor: Colors.blue, useMaterial3: true);
    this.userDocFields = userDocFields ?? [SQStringField("Full Name")];
    this.authManager = authManager ?? FirebaseAuthManager();
    instance = this;
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebaseApp(firebaseOptions);
    usersCollection = FirestoreCollection(
      id: "Users",
      fields: App.instance.userDocFields,
      singleDocName: "Profile Info",
      canDeleteDoc: false,
    );
    await auth.init();
  }

  run(Screen homescreen) {
    runApp(MaterialApp(
        title: name,
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: homescreen));
  }

  getAppPath() {
    return "sample-apps/$name/";
  }
}

Future<FirebaseApp> initializeFirebaseApp(FirebaseOptions options) {
  return Firebase.initializeApp(options: options);
}
