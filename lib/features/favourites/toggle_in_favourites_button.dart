import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/features/favourites/favourites.dart';

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
