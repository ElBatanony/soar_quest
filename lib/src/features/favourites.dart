import 'package:flutter/material.dart';

import '../screens/collection_screen.dart';
import '../screens/doc_screen.dart';
import '../sq_auth.dart';
import '../db/local_collection.dart';
import '../db/sq_action.dart';
import '../db/sq_collection.dart';
import '../db/fields/sq_ref_field.dart';

class FavouritesFeature {
  SQCollection collection;
  late final SQCollection favouritesCollection;

  SQAction addToFavouritesAction() => CustomAction(
        "Fav",
        icon: Icons.favorite,
        show: isInFavourites().not,
        customExecute: (doc, screenState) async {
          var newFavDoc = SQDoc(doc.id, collection: favouritesCollection);
          newFavDoc.getField<SQRefField>("ref")!.value = doc.ref;
          await favouritesCollection.saveDoc(newFavDoc);
          screenState.refreshScreen();
        },
      );

  SQAction removeFromFavouritesAction() => CustomAction(
        "UnFav",
        icon: Icons.delete_forever_sharp,
        show: isInFavourites(),
        customExecute: (doc, screenState) async {
          await favouritesCollection.deleteDoc(doc);
          screenState.refreshScreen();
        },
      );

  FavouritesFeature({required this.collection}) {
    favouritesCollection = LocalCollection(
        id: "Favourite ${collection.id}",
        fields: [SQRefField("ref", collection: collection)],
        actions: [
          GoScreenAction("",
              screen: (doc) =>
                  DocScreen(collection.getDoc(doc.value<SQRef>("ref")!.docId)!))
        ],
        parentDoc: SQAuth.userDoc,
        updates: SQUpdates.readOnly());
    collection.actions
        .addAll([addToFavouritesAction(), removeFromFavouritesAction()]);
    favouritesCollection.loadCollection();
  }

  DocCond isInFavourites() =>
      DocCond((doc, _) => favouritesCollection.hasDoc(doc));
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen(
      {required FavouritesFeature favouritesFeature, super.isInline, super.key})
      : super(
            collection: favouritesFeature.favouritesCollection,
            docScreen: (favDoc) => DocScreen(favDoc.value<SQRef>("ref")!.doc));
}
