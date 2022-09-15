import 'package:flutter/material.dart';

import '../../data.dart';
import '../feature.dart';
import '../../screens/collection_screen.dart';
import '../../screens/screen.dart';
import '../../app.dart';
import 'toggle_in_favourites_button.dart';
import '../../components/buttons/sq_button.dart';

class FavouritesFeature extends Feature {
  static final SQUserCollection _favouritesCollection = FirestoreUserCollection(
      id: "Favourites",
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
      FavouritesScreen(collection: _favouritesCollection);

  static loadFavourites() {
    _favouritesCollection.loadCollection();
  }

  static bool isInFavourites(SQDoc doc) {
    return _favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == doc.id);
  }
}

class FavouritesScreenButton extends StatelessWidget {
  const FavouritesScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SQButton("Go to Favourites",
        onPressed: () =>
            goToScreen(FavouritesFeature.favouritesScreen, context: context));
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
    // TODO: add option to go to original doc screen (not fav doc screen)
    return ListTile(
      title: Text(doc.identifier),
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
