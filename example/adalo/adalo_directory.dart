// import 'package:flutter/material.dart';
// import 'package:soar_quest/soar_quest.dart';

// import '../firebase_options.dart';

// void main() async {
//   List<SQField<dynamic>> userDocFields = [SQFileField("Profile Picture")];

//   await SQApp.init("Date Night",
//       userDocFields: userDocFields,
//       theme:
//           ThemeData(primaryColor: Colors.deepPurpleAccent, useMaterial3: true),
//       firebaseOptions: DefaultFirebaseOptions.currentPlatform);

//   SQCollection categoriesCollection = FirestoreCollection(
//       id: "Categories",
//       fields: [
//         SQStringField("Name"),
//         SQImageField("Picture"),
//       ],
//       singleDocName: "Category");

//   SQRefField dateCategoryRefField =
//       SQRefField("Category", collection: categoriesCollection);

//   SQCollection datesCollection = FirestoreCollection(
//     id: "Dates",
//     fields: [
//       SQStringField("Name"),
//       SQStringField("Tip"),
//       SQImageField("Date Image"),
//       SQStringField("Location"),
//       SQStringField("Full Description"),
//       SQEditedByField("Created By"),
//       dateCategoryRefField,
//       // UpdatedDateField("Last Updated"),
//     ],
//   );

//   FavouritesFeature favouriteDates =
//       FavouritesFeature(collection: datesCollection);

//   CollectionSlice myDates = CollectionSlice(datesCollection,
//       filter: DocRefFilter("Created By", SQAuth.userDoc.ref));

//   SQApp.run(
//     SQNavBar([
//       CollectionScreen(collection: datesCollection),
//       CategorySelectScreen(
//         collection: datesCollection,
//         categoryField: dateCategoryRefField,
//       ),
//       CollectionScreen(title: "My Dates", collection: myDates),
//       CollectionScreen(title: "Categories", collection: categoriesCollection),
//       FavouritesScreen(favouritesFeature: favouriteDates),
//       ProfileScreen(),
//     ]),
//     drawer: SQDrawer([ProfileScreen()]),
//   );
// }
