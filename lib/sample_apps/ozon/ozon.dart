// ignore_for_file: unused_local_variable, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/apps/app.dart';
import 'package:soar_quest/apps/app_display.dart';
import 'package:soar_quest/data_objects/data_collection.dart';
import 'package:soar_quest/data_objects/data_object.dart';
import 'package:soar_quest/firebase_options.dart';
import 'package:soar_quest/screens/collection_display_screen.dart';
import 'package:soar_quest/screens/data_display_screen.dart';
import 'package:soar_quest/screens/menu_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App ozonApp = App("Ozon");
  App.instance.currentUser = UserData(userId: "testuser123");

  // final Navigation
  // final MenuScreen homescreen = MenuScreen("Tinkoff Homescreen",
  //     [Screen("Profile"), Screen('Payments')]);
  // tinkoffApp.homescreen = homescreen;

  ozonApp.run();
}
