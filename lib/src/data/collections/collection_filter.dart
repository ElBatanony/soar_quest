import '../../fields/ref_field.dart';
import '../sq_doc.dart';

abstract class CollectionFilter {
  List<SQDoc> filter(List<SQDoc> docs);

  CollectionFilter get inverse => InverseFilter(this);
}

class InverseFilter extends CollectionFilter {
  InverseFilter(this.originalFilter);

  CollectionFilter originalFilter;

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final filtered = originalFilter.filter(docs);
    return docs.where((doc) => filtered.contains(doc) == false).toList();
  }
}

class ValueFilter extends CollectionFilter {
  ValueFilter(this.fieldName, this.fieldValue);

  String fieldName;
  dynamic fieldValue;

  @override
  List<SQDoc> filter(List<SQDoc> docs) => docs
      .where((doc) => doc.getValue<dynamic>(fieldName) == fieldValue)
      .toList();
}

class RefFilter extends CollectionFilter {
  RefFilter(this.fieldName, this.fieldValue);

  String fieldName;
  SQRef? fieldValue;

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    if (fieldValue == null) return [];
    return docs.where((doc) {
      if (doc.getValue<SQRef>(fieldName) == null) return false;
      final docRef = doc.getValue<SQRef>(fieldName);
      if (docRef == null) throw Exception('Filtering null docRef');
      return docRef.docId == fieldValue!.docId &&
          docRef.collectionPath == fieldValue!.collectionPath;
    }).toList();
  }
}
