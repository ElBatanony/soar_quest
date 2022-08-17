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

  UserData? currentUser;
  Screen? currentScreen;
  ThemeData? theme;

  bool inDebug;

  void setScreen(Screen screen) {
    currentScreen = screen;
    // AppDebugger.refresh();
  }

  static late App instance;

  App(this.name, {this.theme, this.inDebug = false}) {
    instance = this;
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
