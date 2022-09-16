import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

class FavouriteClassTypesFilter extends DocsFilter {
  FavouritesFeature favouritesFeature;

  FavouriteClassTypesFilter({required this.favouritesFeature});

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final classes = docs;
    return classes.where((aclass) {
      SQDocReference classType = aclass.getFieldValueByName("Class Type");
      print(classType);
      bool isClassInFavedType = favouritesFeature.favouritesCollection.favDocs
          .any((favedClassType) =>
              favedClassType.favedDocRef.docId == classType.docId);
      return isClassInFavedType;
    }).toList();
  }
}

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

  FavouritesFeature favouriteClassTypes =
      FavouritesFeature(collection: classTypes);

  DocScreen classTypeDocScreen(SQDoc doc) {
    return DocScreen(
      doc,
      postbody: (context) => Column(
        children: [
          favouriteClassTypes.addToFavouritesButton(doc),
          CollectionFilterScreen(collection: classes, filters: [
            DocRefFilter(
                docRefField: SQDocReferenceField("Class Type",
                    collection: doc.collection,
                    value: SQDocReference.fromDoc(doc)))
          ]).button(context)
        ],
      ),
    );
  }

  adaloAppointmentsApp.homescreen = MainScreen([
    CollectionScreen(
      title: "Learn",
      collection: requests,
    ),
    CollectionScreen(
      collection: classes,
    ),
    CollectionScreen(
      collection: classTypes,
      docScreen: classTypeDocScreen,
    ),
    // CollectionScreen("Class Types", collection: classTypes),
    FavouritesScreen(
      favouritesFeature: favouriteClassTypes,
      docScreen: classTypeDocScreen,
      postbody: (context) => CollectionFilterScreen(
          title: "Matching Classes",
          collection: classes,
          filters: [
            FavouriteClassTypesFilter(
              favouritesFeature: favouriteClassTypes,
            )
          ]).button(context),
    ),
    ProfileScreen("Profile"),
  ]);

  adaloAppointmentsApp.run();
}
