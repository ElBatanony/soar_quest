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
        SQStringField("Readonly String",
            value: "I am readonly", editable: false),
      ],
      singleDocName: "Test Doc");

  SQCollection testUserCollection = FirestoreCollection(
      id: "Test User Collection",
      parentDoc: SQAuth.userDoc,
      fields: [
        SQStringField("Name"),
      ]);

  SQApp.run(
    SQNavBar([
      CollectionScreen(
        collection: testCollection,
        docScreen: (doc) => DocScreen(
          doc,
          // postbody: (context) => SQButton("Go to child collection",
          //     onPressed: () => CollectionScreen(
          //             collection: FirestoreCollection(
          //                 id: "Child Collection",
          //                 fields: [
          //                   SQStringField("Name"),
          //                   SQRefField("Parent Doc",
          //                       collection: testCollection,
          //                       value: doc.ref,
          //                       editable: false),
          //                 ],
          //                 parentDoc: doc))
          //         .go(context)),
          // TODO: implement as Action
        ),
      ),
      CollectionScreen(collection: simpleCollection),
    ]),
    drawer: SQDrawer([
      CollectionScreen(collection: testUserCollection),
      ProfileScreen(),
    ]),
  );
}
