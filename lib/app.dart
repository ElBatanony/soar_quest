import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/db.dart';
import 'firebase_options.dart';

import 'app/app_display.dart';
import 'app/app_settings.dart';
import 'app/auth_manager.dart';

import 'screens/screen.dart';

export 'app/app_navigator.dart';
export 'app/app_settings.dart';
export 'app/auth_manager.dart';

class App {
  String name;
  Screen? homescreen;

  Screen? currentScreen;
  ThemeData theme;

  List<SQCollection> collections = [];

  bool inDebug;
  bool emulatingCloudFunctions;

  late SQAuthManager authManager;

  static SQAuthManager auth = instance.authManager;
  static String get userId => auth.user.userId;

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
      id: "users",
      fields: App.instance.userDocFields,
      singleDocName: "Profile Info",
      canDeleteDoc: false,
    );
    await auth.init();
    await settings.init();
  }

  run() {
    runApp(AppDisplay(this));
  }

  getAppPath() {
    return "sample-apps/$name/";
  }
}
