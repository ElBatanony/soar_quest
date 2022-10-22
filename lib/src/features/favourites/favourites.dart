import 'package:flutter/material.dart';

import '../../auth/sq_auth.dart';
import '../../db/conditions.dart';
import '../../db/local_collection.dart';
import '../../db/sq_action.dart';
import '../../db/sq_collection.dart';
import '../../db/fields/sq_ref_field.dart';
import '../../screens/collection_screen.dart';
import '../../ui/snackbar.dart';
import '../../ui/sq_button.dart';

class FavDoc extends SQDoc {
  SQRef? favedDocRef;

  FavDoc(super.id, {required this.favedDocRef, required super.collection});

  FavDoc.fromDoc(SQDoc doc)
      : this(doc.id,
            favedDocRef: doc.value<SQRef>('ref'), collection: doc.collection);
}

class FavouritesCollection extends LocalCollection {
  List<FavDoc> favDocs = [];

  FavouritesCollection({required super.id, required super.fields})
      : super(parentDoc: SQAuth.userDoc);

  @override
  Future<void> loadCollection() async {
    await super.loadCollection();
    favDocs = docs.map((doc) => FavDoc.fromDoc(doc)).toList();
  }
}

class FavouritesFeature {
  SQCollection collection;
  late final FavouritesCollection favouritesCollection;

  SQAction addToFavouritesAction() => CustomAction(
        "Fav",
        icon: Icons.favorite,
        show: isInFavourites().not(),
        customExecute: (doc, context) async {
          var newFavDoc = SQDoc(doc.id, collection: favouritesCollection);
          newFavDoc.getField<SQRefField>("ref")!.value = doc.ref;
          favouritesCollection.saveDoc(newFavDoc);
        },
      );

  SQAction removeFromFavouritesAction() => CustomAction("UnFav",
          icon: Icons.delete_forever_sharp,
          show: isInFavourites(), customExecute: (doc, context) async {
        favouritesCollection.deleteDoc(doc);
      });

  FavouritesFeature({required this.collection}) {
    favouritesCollection = FavouritesCollection(
      id: "Favourite ${collection.id}",
      fields: [
        SQRefField("ref", collection: collection),
      ],
    );
    collection.actions
        .addAll([addToFavouritesAction(), removeFromFavouritesAction()]);
    favouritesCollection.loadCollection();
  }

  DocCond isInFavourites() =>
      DocCond((doc, _) => favouritesCollection.hasDoc(doc));
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen(
      {required FavouritesFeature favouritesFeature,
      super.docScreen,
      super.isInline,
      super.key})
      : super(collection: favouritesFeature.favouritesCollection);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends CollectionScreenState<FavouritesScreen> {
  @override
  Widget docDisplay(SQDoc doc, BuildContext context) {
    SQRef? originalDocRef = doc.value<SQRef>("ref");
    return ListTile(
      title: SQButton(doc.label,
          onPressed: () async => originalDocRef == null
              ? showSnackBar("Doc Ref is Null", context: context)
              : widget.docScreen(await originalDocRef.doc()).go(context)),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return docs.isEmpty
        ? Center(child: Text("Your favourites list is empty"))
        : super.screenBody(context);
  }
}
