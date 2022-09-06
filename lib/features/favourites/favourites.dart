import 'package:flutter/material.dart';
import 'package:soar_quest/data/firestore.dart';
import 'package:soar_quest/features/feature.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import '../../app/app.dart';
import 'toggle_in_favourites_button.dart';
import '../../components/buttons/sq_button.dart';

class FavouritesFeature extends Feature {
  static final SQUserCollection _favouritesCollection = FirestoreUserCollection(
      id: "favourites",
      fields: [
        SQStringField("identifier"),
      ],
      userId: App.auth.user.userId);

  static Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc);
  }

  static addFavourite(SQDoc doc) {
    var newFavDoc =
        SQDoc(doc.id, collection: FavouritesFeature._favouritesCollection);
    newFavDoc.setData({"identifier": doc.identifier});
    FavouritesFeature._favouritesCollection.createDoc(newFavDoc);
  }

  static removeFavourite(SQDoc favDoc) {
    FavouritesFeature._favouritesCollection.deleteDoc(favDoc.id);
  }

  static Screen favouritesScreen =
      FavouritesScreen("Favourites", collection: _favouritesCollection);

  static loadFavourites() {
    _favouritesCollection.loadCollection();
  }

  static bool isInFavourites(SQDoc doc) {
    return _favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == doc.id);
  }
}

class FavouritesScreen extends CollectionScreen {
  FavouritesScreen(super.title, {required super.collection, super.key});

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
    return ListTile(
      title: Text(doc.identifier),
      trailing: SQButton(
        'Remove',
        onPressed: () => removeFromFavourites(doc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.collection.docs.isEmpty
                ? [Center(child: Text("Your favourites list is empty"))]
                : docsDisplay(context),
          ),
        ));
  }
}
