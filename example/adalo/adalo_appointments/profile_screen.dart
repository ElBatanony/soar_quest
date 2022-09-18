import 'package:flutter/material.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import 'favourite_class_types_filter.dart';

Screen profileScreen({
  required SQCollection classes,
  required FavouritesFeature favouriteClassTypes,
}) {
  DocScreen classTypeDocScreen(SQDoc doc) {
    return DocScreen(
      doc,
      postbody: (context) => Column(
        children: [
          favouriteClassTypes.addToFavouritesButton(doc),
          CollectionFilterScreen(collection: classes, filters: [
            DocRefFilter(
                docRefField: SQDocReferenceField("Class Type",
                    collection: doc.collection,
                    value: SQDocReference.fromDoc(doc)))
          ]).button(context)
        ],
      ),
    );
  }

  return ProfileScreen(
    "Profile",
    postbody: (context) => FavouritesScreen(
      favouritesFeature: favouriteClassTypes,
      docScreen: classTypeDocScreen,
      isInline: true,
      prebody: (context) => Row(
        children: [Text("Interested In")],
      ),
      postbody: (context) => CollectionFilterScreen(
          title: "Matching Classes",
          collection: classes,
          filters: [
            FavouriteClassTypesFilter(
              favouritesFeature: favouriteClassTypes,
            )
          ]).button(context),
    ),
  );
}
