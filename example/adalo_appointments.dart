import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
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
      // print(classType);
      // print(favouritesFeature.favouritesCollection.favDocs);
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

  SQCollection classes = FirestoreCollection(
    id: "Classes",
    fields: [
      SQStringField("Name"),
      SQDocReferenceField("Class Type", collection: classTypes),
      SQUserRefField("Teacher"),
      SQIntField("Teacher's Years of Experience"),
    ],
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

  DocScreen classScreen(SQDoc doc) {
    return DocScreen(
      doc,
      canEdit: false,
      canDelete: false,
      postbody: (context) => SQButton('Request Class',
          onPressed: () => goToScreen(
              DocCreateScreen(
                title: "Book Class",
                submitButtonText: "Submit Request",
                requests,
                initialFields: [
                  requests.getFieldByName("Requested Class").copy()
                    ..value = SQDocReference.fromDoc(doc)
                    ..readOnly = true
                ],
                hiddenFields: [
                  "Status",
                  "Attendee",
                  "Video Meeting Link",
                  "Reschedule Comment"
                ],
              ),
              context: context)),
    );
  }

  classes.docScreen = classScreen;

  adaloAppointmentsApp.homescreen = MainScreen([
    CollectionFilterScreen(
      title: "Classes",
      collection: classes,
      filters: [
        FavouriteClassTypesFilter(
          favouritesFeature: favouriteClassTypes,
        )
      ],
      prebody: (_) => Column(
        children: [Text("Available Classes"), Text("Based On Your Interests")],
      ),
      postbody: (context) =>
          CollectionScreen(title: "All Classes", collection: classes)
              .button(context),
    ),
    CollectionScreen(title: "Learn", collection: requests),

    CollectionScreen(collection: classTypes, docScreen: classTypeDocScreen),
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
