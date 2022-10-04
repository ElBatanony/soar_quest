import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../../screens.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../db/sq_doc.dart';
import 'app_settings.dart';
import 'auth_manager.dart';

class App {
  String name;

  Screen? currentScreen;
  ThemeData theme;

  static List<SQCollection> collections = [];

  bool inDebug;
  bool emulatingCloudFunctions;

  late SQAuthManager authManager;

  static SQAuthManager auth = instance.authManager;
  static String get userId => auth.user.userId;
  static SQDoc get userDoc => auth.user.userDoc;

  late AppSettings settings;

  List<SQDocField> userDocFields;
  List<SQDocField> publicProfileFields;

  static late SQCollection usersCollection;

  void setScreen(Screen screen) {
    currentScreen = screen;
    // AppDebugger.refresh();
  }

  static late App instance;

  App(
    this.name, {
    required this.theme,
    this.inDebug = false,
    this.emulatingCloudFunctions = false,
    AppSettings? settings,
    SQAuthManager? authManager,
    required this.userDocFields,
    this.publicProfileFields = const [],
  }) {
    this.settings = settings ?? AppSettings(settingsFields: []);
    this.authManager = authManager ?? FirebaseAuthManager();
    instance = this;
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    return App.collections.firstWhere((col) => col.getPath() == collectionPath);
  }
}
