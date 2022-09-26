import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/features/favourites/favourites.dart';

class FavouriteClassTypesFilter extends CollectionFilter {
  FavouritesFeature favouritesFeature;

  FavouriteClassTypesFilter({required this.favouritesFeature});

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final classes = docs;
    return classes.where((aclass) {
      SQDocRef classType = aclass.getFieldValueByName("Class Type");
      // print(classType);
      // print(favouritesFeature.favouritesCollection.favDocs);
      bool isClassInFavedType = favouritesFeature.favouritesCollection.favDocs
          .any((favedClassType) =>
              favedClassType.favedDocRef.docId == classType.docId);
      return isClassInFavedType;
    }).toList();
  }
}
