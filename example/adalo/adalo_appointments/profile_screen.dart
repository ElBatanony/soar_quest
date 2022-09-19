import 'package:flutter/material.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import 'config_adalo_appointments.dart';
import 'favourite_class_types_filter.dart';

Screen profileScreen() {
  DocScreen classTypeDocScreen(SQDoc doc) {
    return DocScreen(
      doc,
      postbody: (context) => Column(
        children: [
          favouriteClassTypes.addToFavouritesButton(doc),
          CollectionFilterScreen(collection: classes, filters: [
            DocRefFilter("Class Type", SQDocReference.fromDoc(doc))
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
