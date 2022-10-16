import 'sq_doc.dart';
import 'fields/sq_ref_field.dart';

abstract class CollectionFilter {
  List<SQDoc> filter(List<SQDoc> docs);
}

abstract class CollectionFieldFilter extends CollectionFilter {
  SQField field;
  CollectionFieldFilter(this.field);
}

class ValueFilter extends CollectionFilter {
  String fieldName;
  dynamic fieldValue;
  ValueFilter(this.fieldName, this.fieldValue);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => doc.value<dynamic>(fieldName) == fieldValue)
        .toList();
  }
}

class StringContainsFilter extends CollectionFieldFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => (doc.value(field.name) as String)
            .toLowerCase()
            .contains(field.value.toLowerCase() as String))
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
      if (doc.value<SQRef>(fieldName) == null) return false;
      SQRef? docRef = doc.value<SQRef>(fieldName);
      if (docRef == null) throw "Filtering null docRef";
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}

class DocRefFieldFilter extends CollectionFieldFilter {
  DocRefFieldFilter({required SQRefField docRefField}) : super(docRefField);

  @override
  SQRefField get field => super.field as SQRefField;

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    SQRef? fieldValue = field.value;
    if (fieldValue == null) throw "Null field value ref in DocRefFieldFilter";

    return docs.where((doc) {
      SQRef? docRef = doc.value<SQRef>(field.name);
      if (docRef == null) return false;
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
    return docs.where(
      (doc) {
        Comparable? comparableValue = doc.value<Comparable>(field.name);
        if (comparableValue == null)
          throw "Comparable value is null in CompareFuncFilter";
        return compareFunc(
          comparableValue.compareTo(field.value),
        );
      },
    ).toList();
  }
}
