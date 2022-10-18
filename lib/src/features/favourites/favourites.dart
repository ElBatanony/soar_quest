import 'package:flutter/material.dart';

import '../../auth/sq_auth.dart';
import '../../db/firestore_collection.dart';
import '../../db/sq_collection.dart';
import '../../db/fields/sq_ref_field.dart';
import '../../../screens.dart';
import '../../ui/snackbar.dart';
import 'toggle_in_favourites_button.dart';
import '../../ui/sq_button.dart';

class FavDoc extends SQDoc {
  SQRef? favedDocRef;

  FavDoc(super.id, {required this.favedDocRef, required super.collection});

  FavDoc.fromDoc(SQDoc doc)
      : this(doc.id,
            favedDocRef: doc.value<SQRef>('ref'), collection: doc.collection);
}

class FavouritesCollection extends FirestoreCollection {
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

  FavouritesFeature({required this.collection}) {
    favouritesCollection = FavouritesCollection(
      id: "Favourite ${collection.id}",
      fields: [
        SQRefField("ref", collection: collection),
      ],
    );
    favouritesCollection.loadCollection();
  }

  Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc, favouritesFeature: this);
  }

  void addFavourite(SQDoc doc) {
    var newFavDoc = SQDoc(doc.id, collection: favouritesCollection);
    newFavDoc.getField<SQRefField>("ref")!.value = doc.ref;
    favouritesCollection.saveDoc(newFavDoc);
  }

  void removeFavourite(SQDoc favDoc) {
    favouritesCollection.deleteDoc(favDoc);
  }

  void loadFavourites() {
    favouritesCollection.loadCollection();
  }

  bool isInFavourites(SQDoc doc) {
    return favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == doc.id);
  }
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen(
      {required FavouritesFeature favouritesFeature,
      super.docScreen,
      super.prebody,
      super.postbody,
      super.isInline,
      super.key})
      : super(collection: favouritesFeature.favouritesCollection);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends CollectionScreenState<FavouritesScreen> {
  void removeFromFavourites(SQDoc doc) async {
    await doc.collection.deleteDoc(doc);
    refreshScreen();
  }

  @override
  Widget docDisplay(SQDoc doc) {
    SQRef? originalDocRef = doc.value<SQRef>("ref");

    return ListTile(
      title: SQButton(doc.label,
          onPressed: () async => originalDocRef != null
              ? showSnackBar("Doc Ref is Null", context: context)
              : widget.docScreen(await originalDocRef!.doc()).go(context)),
      trailing: SQButton(
        'Remove',
        onPressed: () => removeFromFavourites(doc),
      ),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
        children: widget.collection.docs.isEmpty
            ? [Center(child: Text("Your favourites list is empty"))]
            : docsDisplay(context));
  }
}
