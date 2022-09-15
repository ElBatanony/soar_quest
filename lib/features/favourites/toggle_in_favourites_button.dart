import 'package:flutter/material.dart';

import '../../data/db.dart';
import 'favourites.dart';

class ToggleInFavouritesButton extends StatefulWidget {
  final FavouritesFeature favouritesFeature;
  final SQDoc doc;
  const ToggleInFavouritesButton(this.doc,
      {required this.favouritesFeature, super.key});

  @override
  State<ToggleInFavouritesButton> createState() =>
      _ToggleInFavouritesButtonState();
}

class _ToggleInFavouritesButtonState extends State<ToggleInFavouritesButton> {
  bool inFavourites = false;

  @override
  void initState() {
    widget.favouritesFeature.loadFavourites();
    inFavourites = widget.favouritesFeature.isInFavourites(widget.doc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          print("Toggling ${widget.doc.id} in favs");
          if (inFavourites) {
            widget.favouritesFeature.removeFavourite(widget.doc);
          } else {
            widget.favouritesFeature.addFavourite(widget.doc);
          }
          inFavourites = !inFavourites;
          widget.favouritesFeature.loadFavourites();
          setState(() {});
        },
        child: inFavourites
            ? Text("Remove from Favourites")
            : Text("Add to Favourites"));
  }
}
