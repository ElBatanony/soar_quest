import 'package:flutter/material.dart';

import '../auth/firebase_auth_manager.dart';
import '../db/fields/sq_string_field.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import 'firebase_app.dart';
import '../screens/screen.dart';
import 'app_settings.dart';
import '../auth/auth_manager.dart';

class App {
  String name;
  late ThemeData theme;

  static final List<SQCollection> _collections = [];

  late SQAuthManager authManager;

  static SQAuthManager auth = instance.authManager;
  static String get userId => auth.user.userId;
  static SQDoc get userDoc => auth.user.userDoc;

  late AppSettings settings;

  late List<SQDocField> userDocFields;
  List<SQDocField> publicProfileFields;

  static late SQCollection usersCollection;

  FirebaseOptions firebaseOptions;

  static late App instance;

  App(
    this.name, {
    ThemeData? theme,
    AppSettings? settings,
    SQAuthManager? authManager,
    List<SQDocField>? userDocFields,
    this.publicProfileFields = const [],
    required this.firebaseOptions,
  }) {
    this.theme =
        theme ?? ThemeData(primaryColor: Colors.blue, useMaterial3: true);
    this.userDocFields = userDocFields ?? [SQStringField("Full Name")];
    this.settings = settings ?? AppSettings(settingsFields: []);
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
    await settings.init();
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

  static SQCollection collectionByPath(String collectionPath) {
    return _collections.firstWhere((col) => col.getPath() == collectionPath);
  }

  static void registerCollection(SQCollection collection) {
    _collections.add(collection);
  }
}
