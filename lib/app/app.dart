import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_display.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/firebase_options.dart';

import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/auth_manager.dart';
import 'package:soar_quest/users/user_data.dart';

// import 'app_debugger.dart';

class App {
  String name;
  Screen? homescreen;

  late UserData currentUser;
  Screen? currentScreen;
  ThemeData? theme;

  bool inDebug;
  bool emulatingCloudFunctions;

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
  }) {
    instance = this;
    currentUser = UserData(userId: "anon");
  }

  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppSettings.init();
    AuthManager.init();
  }

  run() {
    runApp(AppDisplay(this));
  }

  getAppPath() {
    return "sample-apps/$name/";
  }
}
