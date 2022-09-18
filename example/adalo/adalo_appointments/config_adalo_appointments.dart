import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/features/favourites/favourites.dart';

import 'classes_screen.dart';

List<SQDocField> userDocFields = [
  SQStringField("Full Name"),
  SQFileField("Profile Picture"),
];

AppSettings settings = AppSettings(
    settingsFields: [SQBoolField("test field"), SQStringField("waow")]);

App adaloAppointmentsApp = App("First Class",
    theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
    settings: settings,
    userDocFields: userDocFields);

SQCollection classTypes =
    FirestoreCollection(id: "Class Types", fields: [SQStringField("Name")]);

SQCollection classes = FirestoreCollection(
  id: "Classes",
  fields: [
    SQStringField("Name"),
    SQDocReferenceField("Class Type", collection: classTypes),
    SQUserRefField("Teacher"),
    SQIntField("Teacher's Years of Experience"),
  ],
  singleDocName: "Class",
  docScreen: (doc) => BookClassScreen(doc, requests: requests),
);

SQCollection requests = FirestoreCollection(id: "Requests", fields: [
  SQDocReferenceField("Requested Class", collection: classes),
  SQTimestampField("Requested Class Date"),
  SQTimeOfDayField("Time"),
  SQStringField("Status", value: "Pending", readOnly: true),
  SQEditedByField("Attendee"),
  SQStringField("Video Meeting Link"),
  SQStringField("Reschedule Comment")
]);

FavouritesFeature favouriteClassTypes =
    FavouritesFeature(collection: classTypes);
