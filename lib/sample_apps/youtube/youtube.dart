// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/app/app_display.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/firebase_options.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/menu_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App youtubeApp = App("YouTube");
  App.instance.currentUser = UserData(userId: "testuser123");

  final cashbackEarnedData = SQDoc(
      'cashbackEarned',
      [
        SQDocField("cashbackEarned", SQDocFieldType.int),
        SQDocField("creditedOn", SQDocFieldType.string)
      ],
      "cashbackEarned",
      userData: true);

  final cashbackEarnedScreen = DocScreen("Cashback Earned", cashbackEarnedData);

  final partnerCashbackCol = SQCollection([
    SQDocField("Partner", SQDocFieldType.string),
    SQDocField("Headline", SQDocFieldType.string),
    SQDocField("Subheader", SQDocFieldType.string)
  ], "partner-cashbacks");

  final partnerCashbackScreen =
      CollectionScreen("Partner Cashbacks", partnerCashbackCol);

  final MenuScreen cashbackBonusesScreen = MenuScreen("Bonuses", [
    cashbackEarnedScreen,
    const Screen("How to get bonuses"),
    const Screen("Partner cashback"),
    Screen("Partner subscriptions"),
    Screen("Increased caschback at month")
  ]);

  List<SQDocField> videoFields = [
    SQDocField("Title", SQDocFieldType.string),
    SQDocField("Channel", SQDocFieldType.string),
    SQDocField("Views", SQDocFieldType.int)
  ];

  SQCollection historyCollection =
      SQCollection(videoFields, "history", userData: true);

  final MenuScreen libraryScreen = MenuScreen("Library", [
    CollectionScreen("History", historyCollection),
    Screen("Your videos"),
    Screen("Your movies"),
    Screen("Playlists")
  ]);

  final MenuScreen homescreen = MenuScreen("YouTube Homescreen", [
    Screen("Profile"),
    Screen('Home'),
    Screen('Subscriptions'),
    libraryScreen
  ]);

  youtubeApp.homescreen = homescreen;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AppDisplay(youtubeApp));
}
