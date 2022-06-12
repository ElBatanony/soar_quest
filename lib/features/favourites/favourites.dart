import 'package:flutter/material.dart';
import 'package:soar_quest/features/feature.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import 'toggle_in_favourites_button.dart';

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

  static Screen favouritesScreen = CollectionScreen(
    "Favourites",
    favouritesCollection,
    collectionScreenBody: FavouritesScreenBody.new,
  );

  static loadFavourites() {
    favouritesCollection.loadCollection();
  }
}

class FavouritesScreenBody extends CollectionScreenBody {
  const FavouritesScreenBody(SQCollection collection,
      {required Function refreshScreen, Key? key})
      : super(collection, refreshScreen: refreshScreen, key: key);

  @override
  State<FavouritesScreenBody> createState() => _FavouritesScreenBodyState();
}

class _FavouritesScreenBodyState extends State<FavouritesScreenBody> {
  List<SQDoc> docs = [];

  void removeFromFavourites(SQDoc doc) {
    doc.collection.deleteDoc(doc.id);
    widget.refreshScreen();
    setState(() {
      docs = doc.collection.docs;
    });
  }

  @override
  void initState() {
    docs = widget.collection.docs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collection.docs.isEmpty) {
      return Center(child: Text("Your favourites list is empty"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.collection.docs.length,
      itemBuilder: (context, i) {
        SQDoc doc = widget.collection.docs[i];
        return ListTile(
          title: Text(
            doc.id,
          ),
          trailing: ElevatedButton(
              onPressed: () => removeFromFavourites(doc),
              child: Text("Remove")),
        );
      },
    );
  }
}
