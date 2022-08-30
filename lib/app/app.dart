import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_display.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/firebase_options.dart';

import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/auth_manager.dart';

// import 'app_debugger.dart';
import '../data.dart';
import '../users/auth_manager.dart';

class App {
  String name;
  Screen? homescreen;

  Screen? currentScreen;
  ThemeData? theme;

  List<SQCollection> collections = [];

  bool inDebug;
  bool emulatingCloudFunctions;

  SQAuthManager authManager;

  static SQAuthManager auth = instance.authManager;
  AppSettings settings;

  void setScreen(Screen screen) {
    currentScreen = screen;
    // AppDebugger.refresh();
  }

  static late App instance;

  App(
    this.name, {
    this.theme,
    this.inDebug = false,
    this.emulatingCloudFunctions = false,
    required this.settings,
    required this.authManager,
  }) {
    instance = this;
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
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
