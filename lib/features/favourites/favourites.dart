import 'package:flutter/material.dart';
import 'package:soar_quest/data/firestore.dart';
import 'package:soar_quest/features/feature.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import 'toggle_in_favourites_button.dart';

class FavouritesFeature extends Feature {
  static final SQCollection _favouritesCollection = FirestoreCollection(
      id: "favourites",
      fields: [
        SQDocField("identifier", SQDocFieldType.string),
      ],
      userData: true);

  static Widget addToFavouritesButton(SQDoc doc) {
    return ToggleInFavouritesButton(doc);
  }

  static addFavourite(SQDoc doc) {
    var newFavDoc = SQDoc(
        doc.id, [SQDocField("identifier", SQDocFieldType.string)],
        collection: FavouritesFeature._favouritesCollection);
    FavouritesFeature._favouritesCollection.createDoc(newFavDoc);
  }

  static removeFavourite(SQDoc favDoc) {
    FavouritesFeature._favouritesCollection.deleteDoc(favDoc.id);
  }

  static Screen favouritesScreen = CollectionScreen(
    "Favourites",
    _favouritesCollection,
    collectionScreenBody: FavouritesScreenBody.new,
  );

  static loadFavourites() {
    _favouritesCollection.loadCollection();
  }

  static bool isInFavourites(SQDoc doc) {
    return _favouritesCollection.docs
        .any((SQDoc someDoc) => someDoc.id == doc.id);
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
            doc.identifier,
          ),
          trailing: ElevatedButton(
              onPressed: () => removeFromFavourites(doc),
              child: Text("Remove")),
        );
      },
    );
  }
}
