import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/data/firestore.dart';
import 'package:soar_quest/screens/category_select_screen.dart';
// import 'package:soar_quest/screens/cloud_function_docs_screen.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
// import 'package:soar_quest/screens/settings_screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App adminApp = App("Tech Admin",
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
      inDebug: false,
      emulatingCloudFunctions: false);

  await adminApp.init();

  FirebaseAuth.instance.signInAnonymously();

  App.instance.currentUser = UserData(userId: "testuser123");

  final coloursCollection = FirestoreCollection(
      id: "Colours",
      fields: [
        SQStringField("name"),
        SQStringField("hexValue"),
        SQFileField("colorFile")
      ],
      singleDocName: "Colour");

  final logsColourField = SQStringField("colour");
  final colorRefField =
      SQDocReferenceField("colorDoc", collection: coloursCollection);
  final logsVideoField = VideoLinkField("logVideo");

  final logsCollection = FirestoreCollection(
      id: "Logs",
      fields: [
        SQStringField("logId"),
        SQTimestampField("date"),
        SQBoolField("payload"),
        logsVideoField,
        // SQDocListField("tags"),
        colorRefField,
        logsColourField,
        // SQDocListField("colours"),
      ],
      singleDocName: "Log");

  final otherLogRefField =
      SQDocReferenceField("otherLogDoc", collection: logsCollection);

  logsCollection.fields.add(otherLogRefField);

  AppSettings.setSettings([
    SQBoolField('paymentError'),
    SQBoolField('newUser'),
    SQBoolField('payment'),
    SQStringField('username'),
    SQBoolField('Log Manual Commands'),
  ]);

  DocsFilter logIdSearchField =
      StringContainsFilter(logsCollection.getFieldByName("logId"));
  DocsFilter payloadFilter =
      DocsFilter(logsCollection.getFieldByName("payload"));

  final logsScreen = CollectionScreen("Logs", collection: logsCollection);

  adminApp.homescreen = MainScreen(
    [
      CollectionScreen("Colours", collection: coloursCollection),
      logsScreen,
      // CollectionScreen("Logs", logsCollection),
      CategorySelectScreen(
        "Colour Cat",
        collection: logsCollection,
        categoryCollection: coloursCollection,
        categoryField: logsColourField,
      ),
      CollectionFilterScreen(
        "Search",
        collection: logsCollection,
        filters: [logIdSearchField, payloadFilter],
      ),
      // SettingsScreen(),
      // CloudFunctionDocsScreen(
      //   "Fetched Logs",
      //   collection: logsCollection,
      // ),
    ],
    initialScreenIndex: 0,
  );

  adminApp.run();
}
