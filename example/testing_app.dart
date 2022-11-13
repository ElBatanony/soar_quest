import 'package:flutter/material.dart';

import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  List<SQField<dynamic>> userDocFields = [
    SQStringField("Name"),
  ];

  await SQApp.init(
    "Testing App",
    theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
    userDocFields: userDocFields,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );

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
      SQStringField("Readonly String", value: "I am readonly", editable: false),
    ],
    actions: [
      GoScreenAction("Child Coll",
          screen: (doc) => CollectionScreen(
              collection: FirestoreCollection(
                  id: "Child Collection",
                  fields: [
                    SQStringField("Name"),
                    SQRefField("Parent Doc",
                        collection: doc.collection,
                        value: doc.ref,
                        editable: false),
                  ],
                  parentDoc: doc)))
    ],
  );

  SQCollection testUserCollection = FirestoreCollection(
      id: "Test User Collection",
      parentDoc: SQAuth.userDoc,
      fields: [
        SQStringField("Name"),
      ]);

  SQApp.run(
    [
      CollectionScreen(collection: testCollection),
      CollectionScreen(collection: simpleCollection),
      FavouritesScreen(
          favouritesFeature: FavouritesFeature(collection: simpleCollection))
    ],
    drawer: SQDrawer([
      CollectionScreen(collection: testUserCollection),
    ]),
  );
}
