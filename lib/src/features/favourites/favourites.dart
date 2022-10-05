import 'package:flutter/material.dart';

import '../../db/firestore_collection.dart';
import '../../db/sq_collection.dart';
import '../../db/fields/sq_doc_ref_field.dart';
import '../../../screens.dart';
import '../../../app.dart';
import 'toggle_in_favourites_button.dart';
import '../../ui/sq_button.dart';

class FavDoc extends SQDoc {
  SQDocRef favedDocRef;

  FavDoc(super.id, {required this.favedDocRef, required super.collection});

  FavDoc.fromDoc(SQDoc doc)
      : this(doc.id, favedDocRef: doc.value('ref'), collection: doc.collection);
}

class FavouritesCollection extends FirestoreCollection {
  List<FavDoc> favDocs = [];

  FavouritesCollection({required super.id, required super.fields})
      : super(parentDoc: App.userDoc);

  @override
  Future loadCollection() async {
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
        SQDocRefField("ref", collection: collection),
      ],
    );
    favouritesCollection.loadCollection();
  }

  Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc, favouritesFeature: this);
  }

  addFavourite(SQDoc doc) {
    var newFavDoc = SQDoc(doc.id, collection: favouritesCollection);
    newFavDoc.setDocFieldByName("ref", doc.ref);
    // newFavDoc.setData({"ref": });
    favouritesCollection.createDoc(newFavDoc);
  }

  removeFavourite(SQDoc favDoc) {
    favouritesCollection.deleteDoc(favDoc.id);
  }

  loadFavourites() {
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
    await doc.collection.deleteDoc(doc.id);
    refreshScreen();
  }

  @override
  Widget docDisplay(SQDoc doc) {
    SQDocRef originalDocRef = doc.value("ref");

    return ListTile(
      title: SQButton(doc.identifier,
          onPressed: () => goToScreen(widget.docScreen(originalDocRef.getDoc()),
              context: context)),
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
