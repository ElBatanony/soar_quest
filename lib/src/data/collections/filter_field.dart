import '../sq_doc.dart';

abstract class CollectionFilterField<T> {
  CollectionFilterField(this.field);
  SQField<T> field;

  String get fieldName => field.name;

  List<SQDoc> filter(List<SQDoc> docs, SQDoc filterDoc) {
    final filterValue = filterDoc.getValue<T>(fieldName);
    if (filterValue == null) return docs;
    return docs.where((doc) {
      final docValue = doc.getValue<T>(field.name);
      if (docValue == null) return false;
      return filterTest(filterValue, docValue);
    }).toList();
  }

  bool filterTest(T? filterValue, T? docValue);
}
