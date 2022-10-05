// import 'package:flutter/material.dart';
// import 'package:soar_quest/db.dart';
// import 'package:soar_quest/features.dart';
// import 'package:soar_quest/screens.dart';

// import 'config_adalo_appointments.dart';
// import 'favourite_class_types_filter.dart';

// Screen profileScreen() {
//   DocScreen classTypeDocScreen(SQDoc doc) {
//     return DocScreen(
//       doc,
//       postbody: (context) => Column(
//         children: [
//           favouriteClassTypes.addToFavouritesButton(doc),
//           CollectionFilterScreen(
//                   collection: classes,
//                   filters: [DocRefFilter("Class Type", SQDocRef.fromDoc(doc))])
//               .button(context)
//         ],
//       ),
//     );
//   }

//   return ProfileScreen(
//     postbody: (context) => FavouritesScreen(
//       favouritesFeature: favouriteClassTypes,
//       docScreen: classTypeDocScreen,
//       isInline: true,
//       prebody: (context) => Row(
//         children: [Text("Interested In")],
//       ),
//       postbody: (context) => CollectionFilterScreen(
//           title: "Matching Classes",
//           collection: classes,
//           filters: [
//             FavouriteClassTypesFilter(
//               favouritesFeature: favouriteClassTypes,
//             )
//           ]).button(context),
//     ),
//   );
// }
