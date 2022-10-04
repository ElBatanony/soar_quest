// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/features/upvotes/upvotes_feature.dart';
import 'package:soar_quest/screens.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("City"),
    SQTimestampField("Birthdate"),
    SQBoolField("Public Profile"),
  ];

  List<SQDocField> publicProfileFields = [
    SQStringField("Username"),
    SQStringField("City"),
    SQTimestampField("Birthdate"),
  ];

  AppSettings settings = AppSettings(settingsFields: [
    SQBoolField('paymentError'),
    SQBoolField('newUser'),
    SQBoolField('payment'),
    SQStringField('username'),
    SQBoolField('Log Manual Commands'),
  ]);

  App adminApp = App(
    "Tech Admin",
    theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
    inDebug: false,
    emulatingCloudFunctions: false,
    settings: settings,
    userDocFields: userDocFields,
    publicProfileFields: publicProfileFields,
  );

  await adminApp.init();

  final coloursCollection = FirestoreCollection(
      id: "Colours",
      fields: [
        SQStringField("name"),
        SQStringField("hexValue"),
        SQFileField("colorFile"),
        SQTimestampField("Upvotes", readOnly: true)
      ],
      singleDocName: "Colour");

  final colorRefField =
      SQDocRefField("colorDoc", collection: coloursCollection);
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
        // SQDocListField("colours"),
      ],
      singleDocName: "Log");

  final otherLogRefField =
      SQDocRefField("otherLogDoc", collection: logsCollection);

  logsCollection.fields.add(otherLogRefField);

  CollectionFilter logIdSearchField =
      StringContainsFilter(logsCollection.getFieldByName("logId")!);

  final logsScreen = CollectionScreen(collection: logsCollection);

  adminApp.run(MainScreen(
    [
      // UpvoteCollectionScreen(
      //   "Col Upvote",
      //   collection: coloursCollection,
      // ),
      CollectionScreen(collection: coloursCollection),
      // PublicProfilesScreen(),

      logsScreen,
      CategorySelectScreen(
        title: "Colour Cat",
        collection: logsCollection,
        categoryField: colorRefField,
      ),
      CollectionFilterScreen(
        title: "Search",
        collection: logsCollection,
        filters: [logIdSearchField],
      ),
      ProfileScreen(),
      // SettingsScreen(),
      // CloudFunctionDocsScreen(
      //   "Fetched Logs",
      //   collection: logsCollection,
      // ),
    ],
    initialScreenIndex: 0,
  ));
}
