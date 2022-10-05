import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/screens.dart';
import 'package:soar_quest/storage.dart';

import 'firebase_options.dart';

void main() async {
  List<SQField> userDocFields = [
    SQStringField("Name"),
  ];

  App testingApp = App("Testing App",
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      userDocFields: userDocFields);

  await testingApp.init();

  SQCollection simpleCollection = FirestoreCollection(
    id: "Simple Collection",
    fields: [
      SQStringField("Name"),
      SQBoolField("Cool?"),
    ],
  );

  SQFileStorage firebaseFileStorage = FirebaseFileStorage();

  SQCollection testCollection = FirestoreCollection(
      id: "Test Collection",
      fields: [
        SQStringField("String"),
        SQBoolField("Bool"),
        SQRefField("Doc Ref", collection: simpleCollection),
        SQDoubleField("Double"),
        SQFileField("File", storage: firebaseFileStorage),
        SQIntField("Int"),
        SQTimeOfDayField("Time of Day"),
        SQTimestampField("Timestamp"),
        SQStringField("Readonly String",
            value: "I am readonly", readOnly: true),
      ],
      singleDocName: "Test Doc");

  SQCollection testUserCollection = FirestoreCollection(
      id: "Test User Collection",
      parentDoc: App.userDoc,
      fields: [
        SQStringField("Name"),
      ]);

  testingApp.run(MainScreen([
    CollectionScreen(
      collection: testCollection,
      canCreate: true,
      docScreen: (doc) => DocScreen(
        doc,
        postbody: (context) => CollectionScreen(
                canCreate: true,
                collection: FirestoreCollection(
                    id: "Child Collection",
                    fields: [
                      SQStringField("Name"),
                      SQRefField("Parent Doc",
                          collection: testCollection,
                          value: doc.ref,
                          readOnly: true),
                    ],
                    parentDoc: doc))
            .button(context),
      ),
    ),
    CollectionScreen(collection: simpleCollection, canCreate: true),
    CollectionScreen(collection: testUserCollection, canCreate: true),
    ProfileScreen(),
  ]));
}
