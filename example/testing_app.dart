import 'package:flutter/material.dart';

import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  final userDocFields = [
    SQStringField('Name'),
  ];

  await SQApp.init(
    'Testing App',
    theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    userDocFields: userDocFields,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );

  await UserSettings.setSettings([SQDarkMode.setting(), SQDateOfBirthField()]);

  final simpleCollection = FirestoreCollection(
    id: 'Simple Collection',
    fields: [
      SQStringField('Name'),
      SQBoolField('Cool?'),
    ],
  );

  final firebaseFileStorage = FirebaseFileStorage();

  final testCollection = FirestoreCollection(
    id: 'Test Collection',
    fields: [
      SQStringField('String'),
      SQBoolField('Bool'),
      SQRefField('Doc Ref', collection: simpleCollection),
      SQDoubleField('Double'),
      SQFileField('File', storage: firebaseFileStorage),
      SQIntField('Int'),
      SQVirtualField(
          subfield: SQIntField('Virtual Int'), valueBuilder: (doc) => 5 + 2),
      SQFieldListField(SQStringField('String List'), defaultValue: ['hi']),
      SQColorField('Color'),
      SQLocationField('Location'),
      SQTimeOfDayField('Time of Day'),
      SQTimestampField('Timestamp'),
      SQStringField('Readonly String',
          defaultValue: 'I am readonly', editable: false),
    ],
    actions: [
      GoScreenAction('Child Coll',
          screen: (doc) => CollectionScreen(
              collection: FirestoreCollection(
                  id: 'Child Collection',
                  fields: [
                    SQStringField('Name'),
                    SQRefField('Parent Doc',
                        collection: doc.collection,
                        defaultValue: doc.ref,
                        editable: false),
                  ],
                  parentDoc: doc)))
    ],
  );

  final testUserCollection = FirestoreCollection(
      id: 'Test User Collection',
      parentDoc: SQAuth.userDoc,
      fields: [
        SQStringField('Name'),
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
