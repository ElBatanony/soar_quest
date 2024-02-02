import 'package:flutter/material.dart';

import 'package:soar_quest/soar_quest.dart';

void main() async {
  await SQApp.init('Testing App');

  await UserSettings.setSettings([SQDarkMode.setting(), SQDateOfBirthField()]);

  final simpleCollection = LocalCollection(
    id: 'Simple Collection',
    fields: [
      SQStringField('Name'),
      SQBoolField('Cool?'),
      SQMaturityRatingField(),
    ],
  );

  final testCollection = LocalCollection(
    id: 'Test Collection',
    fields: [
      SQStringField('String'),
      SQBoolField('Bool'),
      SQQRCodeField('QR'),
      SQEnumField(SQColorField('Color Enum'),
          options: [Colors.red, Colors.blue, Colors.amber]),
      SQRefField('Doc Ref', collection: simpleCollection),
      SQDoubleField('Double'),
      SQIntField('Int'),
      SQVirtualField(SQIntField('Virtual Int'), (doc) => 5 + 2),
      SQFieldListField(SQStringField('String List'))..defaultValue = ['hi'],
      SQColorField('Color'),
      SQLocationField('Location'),
      SQTimeOfDayField('Time of Day'),
      SQTimestampField('Timestamp'),
      SQUpdatedDateField('Updated Date'),
      SQStringField('Readonly String')
        ..defaultValue = 'I am readonly'
        ..editable = false,
    ],
    actions: [
      GoScreenAction('Child Coll',
          toScreen: (doc) => CollectionScreen(
              collection: LocalCollection(
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

  SQApp.run(
    [
      CollectionScreen(collection: testCollection),
      CollectionScreen(collection: KidsModeSlice(simpleCollection)),
      FavouritesScreen(
          favouritesFeature: FavouritesFeature(collection: simpleCollection))
    ],
    drawer: SQDrawer([
      FAQScreen(
          collection: LocalCollection(id: 'FAQ', fields: [
        SQStringField('Question'),
        SQStringField('Answer'),
      ])),
      (Screen('Top Screen')..isInline = true) &
          (Screen('Bottom Screen')..isInline = true),
    ]),
  );
}
