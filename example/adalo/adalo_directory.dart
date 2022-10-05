// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/ui.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/features.dart';
import 'package:soar_quest/screens.dart';

import '../firebase_options.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Full Name"),
    SQFileField("Profile Picture")
  ];

  App adaloDirectoryApp = App("Date Night",
      theme:
          ThemeData(primaryColor: Colors.deepPurpleAccent, useMaterial3: true),
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      userDocFields: userDocFields);

  await adaloDirectoryApp.init();

  SQCollection categoriesCollection = FirestoreCollection(
      id: "Categories",
      fields: [
        SQStringField("Name"),
        SQFileField("Picture"),
      ],
      singleDocName: "Category");

  SQDocRefField dateCategoryRefField =
      SQDocRefField("Category", collection: categoriesCollection);
  SQEditedByField sqEditedByField = SQEditedByField("Created By");

  SQCollection datesCollection = FirestoreCollection(id: "Dates", fields: [
    SQStringField("Name"),
    SQFileField("Date Image"),
    SQStringField("Tip"),
    SQStringField("Location"),
    SQStringField("Full Description"),
    sqEditedByField,
    dateCategoryRefField,
    UpdatedDateField("Last Updated"),
  ]);

  FavouritesFeature favouriteDates =
      FavouritesFeature(collection: datesCollection);

  adaloDirectoryApp.run(MainScreen([
    CollectionScreen(
      collection: datesCollection,
      docScreen: (doc) => DocScreen(doc,
          postbody: (_) => favouriteDates.addToFavouritesButton(doc)),
    ),
    CategorySelectScreen(
      collection: datesCollection,
      categoryField: dateCategoryRefField,
      docScreen: (doc) => DocScreen(doc,
          postbody: (_) => favouriteDates.addToFavouritesButton(doc)),
    ),
    CollectionScreen(
        title: "My Dates",
        collection: ByUserCollection.fromCollection(
            collection: datesCollection, byUserField: sqEditedByField)),
    // CollectionScreen("Categories", collection: categoriesCollection),
    FavouritesScreen(favouritesFeature: favouriteDates),
    ProfileScreen(),
  ]));
}

class ByUserCollection extends FirestoreCollection implements SQCollection {
  SQDocField byUserField;

  ByUserCollection(
      {required super.id, required this.byUserField, required super.fields}) {
    docs = [];
  }

  ByUserCollection.fromCollection({
    required SQCollection collection,
    required SQDocField byUserField,
  }) : this(
          id: collection.id,
          byUserField: byUserField,
          fields: collection.fields,
        );

  @override
  Future loadCollection() async {
    final snap = await ref.where(byUserField.name, isEqualTo: App.userId).get();
    docs = snap.docs
        .map((doc) => SQDoc(doc.id, collection: this)
          ..setData(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
