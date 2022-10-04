import 'sq_doc.dart';
import '../fields/sq_doc_ref_field.dart';
import 'sq_doc_field.dart';

abstract class CollectionFilter {
  List<SQDoc> filter(List<SQDoc> docs);
}

abstract class CollectionFieldFilter extends CollectionFilter {
  SQDocField field;
  CollectionFieldFilter(this.field);
}

class ValueFilter extends CollectionFilter {
  String fieldName;
  dynamic fieldValue;
  ValueFilter(this.fieldName, this.fieldValue);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs.where((doc) => doc.value(fieldName) == fieldValue).toList();
  }
}

class StringContainsFilter extends CollectionFieldFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => (doc.value(field.name) as String)
            .toLowerCase()
            .contains(field.value.toLowerCase()))
        .toList();
  }
}

class DocRefFilter extends CollectionFilter {
  String fieldName;
  dynamic fieldValue;

  DocRefFilter(this.fieldName, this.fieldValue);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs.where((doc) {
      if (doc.value(fieldName) == null) return false;
      SQDocRef docRef = doc.value(fieldName);
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}

class DocRefFieldFilter extends CollectionFieldFilter {
  SQDocRefField docRefField;

  DocRefFieldFilter({required this.docRefField}) : super(docRefField);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs.where((doc) {
      if (doc.value(field.name) == null) return false;

      SQDocRef docRef = doc.value(field.name);
      SQDocRef fieldValue = field.value;
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}

class CompareFuncFilter extends CollectionFieldFilter {
  bool Function(int) compareFunc;

  CompareFuncFilter(super.field, {required this.compareFunc});

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where(
          (doc) => compareFunc(
            doc.value(field.name).compareTo(field.value),
          ),
        )
        .toList();
  }
}
