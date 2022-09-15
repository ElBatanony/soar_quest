import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/fields/sq_time_of_day_field.dart';
import 'package:soar_quest/data/fields/sq_user_ref_field.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Full Name"),
    SQFileField("Profile Picture"),
  ];

  AppSettings settings = AppSettings(
      settingsFields: [SQBoolField("test field"), SQStringField("waow")]);

  App adaloAppointmentsApp = App("First Class",
      theme: ThemeData(primaryColor: Colors.green, useMaterial3: true),
      settings: settings,
      userDocFields: userDocFields);

  await adaloAppointmentsApp.init();

  SQCollection classTypes =
      FirestoreCollection(id: "Class Types", fields: [SQStringField("Name")]);

  SQCollection classes = FirestoreCollection(id: "Classes", fields: [
    SQStringField("Name"),
    SQDocReferenceField("Class Type", collection: classTypes),
    SQUserRefField("Teacher"),
    SQIntField("Teacher's Years of Experience"),
  ]);

  SQCollection requests = FirestoreCollection(id: "Requests", fields: [
    SQDocReferenceField("Requested Class", collection: classes),
    SQTimestampField("Requested Class Date"),
    SQTimeOfDayField("Time"),
    SQStringField("Status"),
    SQEditedByField("Attendee"),
    SQStringField("Video Meeting Link"),
    SQStringField("Reschedule Comment")
  ]);

  FavouritesFeature favouriteClasses = FavouritesFeature(collection: classes);

  adaloAppointmentsApp.homescreen = MainScreen([
    CollectionScreen(
      title: "Learn",
      collection: requests,
    ),
    CollectionScreen(
      collection: classes,
      docScreen: (doc) => DocScreen(
        doc,
        postbody: favouriteClasses.addToFavouritesButton(doc),
      ),
    ),
    // CollectionScreen("Class Types", collection: classTypes),
    favouriteClasses.favouritesScreen,
    ProfileScreen("Profile"),
    settingsScreen()
  ]);

  adaloAppointmentsApp.run();
}
