import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/types/sq_doc_reference.dart';
import '../feature.dart';
import '../../screens/collection_screen.dart';
import '../../screens/doc_screen.dart';
import '../../screens/screen.dart';
import '../../app.dart';
import 'toggle_in_favourites_button.dart';
import '../../components/buttons/sq_button.dart';

class FavouritesFeature extends Feature {
  SQCollection collection;
  late final SQUserCollection _favouritesCollection;

  FavouritesFeature({required this.collection}) {
    _favouritesCollection = FirestoreUserCollection(
        id: "Favourite ${collection.id}",
        fields: [
          SQDocReferenceField("ref", collection: collection),
        ],
        userId: App.auth.user.userId);
  }

  Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc, favouritesFeature: this);
  }

  addFavourite(SQDoc doc) {
    var newFavDoc = SQDoc(doc.id, collection: _favouritesCollection);
    newFavDoc.setDocFieldByName("ref", doc.ref);
    // newFavDoc.setData({"ref": });
    _favouritesCollection.createDoc(newFavDoc);
  }

  removeFavourite(SQDoc favDoc) {
    _favouritesCollection.deleteDoc(favDoc.id);
  }

  Screen get favouritesScreen =>
      FavouritesScreen(collection: _favouritesCollection);

  loadFavourites() {
    _favouritesCollection.loadCollection();
  }

  bool isInFavourites(SQDoc doc) {
    return _favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == doc.id);
  }
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen({super.title, required super.collection, super.key});

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
    SQDocReference originalDocRef = doc.getFieldValueByName("ref");

    return ListTile(
      title: SQButton(doc.identifier,
          onPressed: () =>
              goToScreen(DocScreen(originalDocRef.getDoc()), context: context)),
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
