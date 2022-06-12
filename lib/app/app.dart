import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_display.dart';
import 'package:soar_quest/firebase_options.dart';

import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

class App {
  String name;
  Screen? homescreen;

  UserData? currentUser;

  static late App instance;

  App(this.name) {
    instance = this;
  }

  run() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(AppDisplay(this));
  }

  getAppPath() {
    return "sample-apps/$name/";
  }
}
