import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/screens.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Name"),
  ];

  App testingApp = App("Testing App",
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
      userDocFields: userDocFields);

  await testingApp.init();

  SQCollection simpleCollection = FirestoreCollection(
    id: "Simple Collection",
    fields: [
      SQStringField("Name"),
      SQBoolField("Cool?"),
    ],
  );

  SQCollection testCollection = FirestoreCollection(
      id: "Test Collection",
      fields: [
        SQBoolField("Bool"),
        SQDocRefField("Doc Ref", collection: simpleCollection),
        SQDoubleField("Double"),
        SQFileField("File"),
        SQIntField("Int"),
        SQStringField("String"),
        SQTimeOfDayField("Time of Day"),
        SQTimestampField("Timestamp"),
        SQStringField("Readonly String",
            value: "I am readonly", readOnly: true),
      ],
      singleDocName: "Test Doc");

  testingApp.run(MainScreen([
    CollectionScreen(collection: testCollection, canCreate: true),
    CollectionScreen(collection: simpleCollection, canCreate: true),
    ProfileScreen(),
  ]));
}
