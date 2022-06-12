import 'package:flutter/material.dart';
import 'package:soar_quest/features/feature.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/screen.dart';

class FavouritesFeature extends Feature {
  static SQCollection favouritesCollection = SQCollection(
      "favourites",
      [
        SQDocField("itemName", SQDocFieldType.string),
        SQDocField("docPath", SQDocFieldType.string),
      ],
      userData: true);

  static Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc);
  }

  static Screen favouritesScreen =
      CollectionScreen("Favourites", favouritesCollection);

  static loadFavourites() {
    favouritesCollection.loadCollection();
  }
}

class ToggleInFavouritesButton extends StatefulWidget {
  final SQDoc doc;
  const ToggleInFavouritesButton(this.doc, {Key? key}) : super(key: key);

  @override
  State<ToggleInFavouritesButton> createState() =>
      _ToggleInFavouritesButtonState();
}

class _ToggleInFavouritesButtonState extends State<ToggleInFavouritesButton> {
  bool inFavourites = false;

  @override
  void initState() {
    FavouritesFeature.favouritesCollection.loadCollection();
    inFavourites = FavouritesFeature.favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == widget.doc.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          print("Toggling ${widget.doc.id} in favs");
          if (inFavourites) {
            FavouritesFeature.favouritesCollection.deleteDoc(widget.doc.id);
          } else {
            FavouritesFeature.favouritesCollection.createDoc(SQDoc(
                widget.doc.id, widget.doc.fields,
                collection: FavouritesFeature.favouritesCollection));
          }
          inFavourites = !inFavourites;
          FavouritesFeature.loadFavourites();
          setState(() {});
        },
        child: inFavourites
            ? Text("Remove from Favourites")
            : Text("Add to Favourites"));
  }
}
