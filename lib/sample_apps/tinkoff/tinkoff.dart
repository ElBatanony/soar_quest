// ignore_for_file: unused_local_variable

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
  App tinkoffApp = App("Tinkoff");
  App.instance.currentUser = UserData(userId: "testuser123");

  final cashbackEarnedData = DataObject(
      'cashbackEarned',
      [
        DataField("cashbackEarned", DataFieldType.int),
        DataField("creditedOn", DataFieldType.string)
      ],
      "cashbackEarned",
      userData: true);

  final cashbackEarnedScreen =
      DataDisplayScreen("Cashback Earned", cashbackEarnedData);

  final partnerCashbackCol = DataCollection([
    DataField("Partner", DataFieldType.string),
    DataField("Headline", DataFieldType.string),
    DataField("Subheader", DataFieldType.string)
  ], "partner-cashbacks");

  final partnerCashbackScreen =
      CollectionDisplayScreen("Partner Cashbacks", partnerCashbackCol);

  final MenuScreen cashbackBonusesScreen = MenuScreen("Bonuses", [
    cashbackEarnedScreen,
    const Screen("How to get bonuses"),
    partnerCashbackScreen,
    Screen("Partner subscriptions"),
    Screen("Increased caschback at month")
  ]);

  final MenuScreen homescreen = MenuScreen("Tinkoff Homescreen",
      [Screen("Profile"), Screen('Payments'), cashbackBonusesScreen]);
  tinkoffApp.homescreen = homescreen;
  // tinkoffApp.homescreen = partnerCashbackScreen;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AppDisplay(tinkoffApp));
}
