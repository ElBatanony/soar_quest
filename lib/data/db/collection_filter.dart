import '../db.dart';
import '../types/sq_doc_reference.dart';

abstract class CollectionFilter<DocType extends SQDoc> {
  List<DocType> filter(List<DocType> docs);
}

abstract class CollectionFieldFilter<DocType extends SQDoc>
    extends CollectionFilter<DocType> {
  SQDocField field;
  CollectionFieldFilter(this.field);
}

class ValueFilter<DocType extends SQDoc> extends CollectionFilter<DocType> {
  String fieldName;
  dynamic fieldValue;
  ValueFilter(this.fieldName, this.fieldValue);

  @override
  List<DocType> filter(List<DocType> docs) {
    return docs
        .where((doc) => doc.getFieldValueByName(fieldName) == fieldValue)
        .toList();
  }
}

class StringContainsFilter extends CollectionFieldFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => (doc.getFieldValueByName(field.name) as String)
            .toLowerCase()
            .contains(field.value.toLowerCase()))
        .toList();
  }
}

class DocRefFilter<DocType extends SQDoc> extends CollectionFilter<DocType> {
  String fieldName;
  dynamic fieldValue;

  DocRefFilter(this.fieldName, this.fieldValue);

  @override
  List<DocType> filter(List<DocType> docs) {
    return docs.where((doc) {
      if (doc.getFieldValueByName(fieldName) == null) return false;
      SQDocRef docRef = doc.getFieldValueByName(fieldName);
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
      if (doc.getFieldValueByName(field.name) == null) return false;

      SQDocRef docRef = doc.getFieldValueByName(field.name);
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
            doc.getFieldValueByName(field.name).compareTo(field.value),
          ),
        )
        .toList();
  }
}
