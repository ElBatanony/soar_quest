import 'in_memory_collection.dart';

class FiltersCollection extends InMemoryCollection {
  FiltersCollection(
    SQCollection collection,
  ) : super(
            id: '${collection.id}_filters',
            filters: collection.filters,
            fields: collection.filters.map((filter) => filter.field).toList());
}

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

class EqualValueFilter extends CollectionFilterField<dynamic> {
  EqualValueFilter(super.field);

  @override
  bool filterTest(filterValue, docValue) => filterValue == docValue;
}

class TextSearchFiler extends CollectionFilterField<String> {
  TextSearchFiler(super.field);

  @override
  bool filterTest(String? filterValue, String? docValue) =>
      docValue?.toLowerCase().contains(filterValue!.toLowerCase()) ?? true;
}
