import 'package:flutter/material.dart';

import '../../mini_apps.dart';
import '../data/collections/local_collection.dart';
import '../data/sq_action.dart';
import '../fields/ref_field.dart';
import '../screens/collection_screen.dart';
import '../screens/doc_screen.dart';
import '../screens/screen.dart';

class FavouritesFeature {
  FavouritesFeature({required this.collection}) {
    favouritesCollection = MiniAppCollection(
        id: 'Favourite ${collection.id}',
        fields: [SQRefField('ref', collection: collection)],
        actions: [
          GoScreenAction('',
              toScreen: (doc) => DocScreen(
                  collection.getDoc(doc.getValue<SQRef>('ref')!.docId)!))
        ],
        updates: SQUpdates.readOnly());
    collection.actions
        .addAll([addToFavouritesAction(), removeFromFavouritesAction()]);
  }

  SQCollection collection;
  late final SQCollection favouritesCollection;

  SQAction addToFavouritesAction() => CustomAction(
        'Fav',
        icon: Icons.favorite,
        show: isInFavourites().not,
        customExecute: (doc, screen) async {
          final newFavDoc = SQDoc(doc.id, collection: favouritesCollection)
            ..setValue('ref', doc.ref);
          await favouritesCollection.saveDoc(newFavDoc);
          screen.refresh();
        },
      );

  SQAction removeFromFavouritesAction() => CustomAction(
        'UnFav',
        icon: Icons.delete_forever_sharp,
        show: isInFavourites(),
        customExecute: (doc, screen) async {
          await favouritesCollection.deleteDoc(doc);
          screen.refresh();
        },
      );

  Future<void> loadFavourites() => favouritesCollection.loadCollection();

  DocCond isInFavourites() =>
      DocCond((doc, _) => favouritesCollection.hasDoc(doc));
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen({required FavouritesFeature favouritesFeature})
      : super(collection: favouritesFeature.favouritesCollection);

  @override
  Screen docScreen(SQDoc doc) => DocScreen(doc.getValue<SQRef>('ref')!.doc);
}
