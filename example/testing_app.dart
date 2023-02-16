import 'package:flutter/material.dart';

import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  final userDocFields = [
    SQStringField('Name'),
  ];

  await SQApp.init(
    'Testing App',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true),
    userDocFields: userDocFields,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    analytics: SQFirebaseAnalytics(),
  );

  await UserSettings.setSettings([SQDarkMode.setting(), SQDateOfBirthField()]);

  final simpleCollection = FirestoreCollection(
    id: 'Simple Collection',
    fields: [
      SQStringField('Name'),
      SQBoolField('Cool?'),
      SQMaturityRatingField(),
    ],
  );

  final firebaseFileStorage = FirebaseFileStorage();

  final testCollection = FirestoreCollection(
    id: 'Test Collection',
    fields: [
      SQStringField('String'),
      SQBoolField('Bool'),
      SQQRCodeField('QR'),
      SQEnumField(SQColorField('Color Enum'),
          options: [Colors.red, Colors.blue, Colors.amber]),
      SQRefField('Doc Ref', collection: simpleCollection),
      SQEditedByField('Edited By'),
      SQDoubleField('Double'),
      SQIntField('Int'),
      SQVirtualField(SQIntField('Virtual Int'), (doc) => 5 + 2),
      SQFieldListField(SQStringField('String List'))..defaultValue = ['hi'],
      SQColorField('Color'),
      SQLocationField('Location'),
      SQTimeOfDayField('Time of Day'),
      SQTimestampField('Timestamp'),
      SQCreatedByField('Creator'),
      SQUpdatedDateField('Updated Date'),
      SQStringField('Readonly String')
        ..defaultValue = 'I am readonly'
        ..editable = false,
      SQFileField('File', storage: firebaseFileStorage),
    ],
    actions: [
      GoScreenAction('Child Coll',
          toScreen: (doc) => CollectionScreen(
              collection: FirestoreCollection(
                  id: 'Child Collection',
                  fields: [
                    SQStringField('Name'),
                    SQRefField('Parent Doc', collection: doc.collection)
                      ..defaultValue = doc.ref
                      ..editable = false,
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
      CollectionScreen(collection: KidsModeSlice(simpleCollection)),
      FavouritesScreen(
          favouritesFeature: FavouritesFeature(collection: simpleCollection))
    ],
    drawer: SQDrawer([
      CollectionScreen(collection: testUserCollection),
      FAQScreen(
          collection: FirestoreCollection(id: 'FAQ', fields: [
        SQStringField('Question'),
        SQStringField('Answer'),
      ])),
      (Screen('Top Screen')..isInline = true) &
          (Screen('Bottom Screen')..isInline = true),
    ]),
  );
}
