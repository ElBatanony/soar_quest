// import 'package:flutter/material.dart';
// import 'package:soar_quest/app/app.dart';
// import 'package:soar_quest/app/app_navigator.dart';
// import 'package:soar_quest/components/buttons/sq_button.dart';
// import 'package:soar_quest/data/firestore.dart';
// import 'package:soar_quest/data.dart';
// import 'package:soar_quest/features/favourites/favourites.dart';
// import 'package:soar_quest/screens/collection_screen.dart';
// import 'package:soar_quest/screens/doc_screen.dart';
// import 'package:soar_quest/screens/main_screen.dart';
// import 'package:soar_quest/screens/screen.dart';
// import 'package:soar_quest/users/user_data.dart';

// void main() async {
//   App ozonApp = App("Ozon");
//   await ozonApp.init();

//   App.instance.currentUser = UserData(userId: "testuser123");

//   final catalogueCollection = FirestoreCollection(id: "catalogue", fields: [
//     SQStringField("Item Name"),
//     SQDocField<int>("Item Price"),
//   ]);

//   final catalogueScreen = CatalogueScreen(
//     "Catalogue",
//     collection: catalogueCollection,
//   );

//   FavouritesFeature.loadFavourites();

//   ozonApp.homescreen = MainScreen(
//     [
//       Screen("Main"),
//       Screen('Fresh'),
//       catalogueScreen,
//       Screen('Cart'),
//       FavouritesFeature.favouritesScreen
//     ],
//     initialScreenIndex: 2,
//   );

//   ozonApp.run();
// }

// class CatalogueDocBody extends DocScreen {
//   CatalogueDocBody(super.title, super.doc,
//       {required super.refreshCollectionScreen, super.key});

//   @override
//   State<CatalogueDocBody> createState() => _CataglogueDocBodyState();
// }

// class _CataglogueDocBodyState extends DocScreenState<CatalogueDocBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.doc.identifier),
//       ),
//       body: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Text("this is the custom diplay of the ozon catalogue item"),
//           Text("custom display"),
//           FavouritesFeature.addToFavouritesButton(widget.doc)
//         ]),
//       ),
//     );
//   }
// }

// class CatalogueScreen extends CollectionScreen {
//   CatalogueScreen(super.title, {required super.collection, super.key});

//   @override
//   State<CatalogueScreen> createState() => _CatalogueScreenState();
// }

// class _CatalogueScreenState extends CollectionScreenState<CatalogueScreen> {
//   @override
//   Widget docDisplay(SQDoc doc) {
//     return SQButton(doc.identifier, onPressed: () {
//       goToScreen(
//           CatalogueDocBody("doc page", doc,
//               refreshCollectionScreen: refreshScreen),
//           context: context);
//     });
//   }
// }
