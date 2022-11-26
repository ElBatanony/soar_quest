import '../../sq_auth.dart';
import '../fields/sq_ref_field.dart';
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

abstract class CollectionFieldFilter extends CollectionFilter {
  CollectionFieldFilter(this.field);

  SQField<dynamic> field;
}

class FieldValueFilter<T> extends CollectionFieldFilter {
  FieldValueFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) => docs
      .where((doc) => doc.value<T>(field.name) == field.value as T)
      .toList();
}

class ValueFilter extends CollectionFilter {
  ValueFilter(this.fieldName, this.fieldValue);

  String fieldName;
  dynamic fieldValue;

  @override
  List<SQDoc> filter(List<SQDoc> docs) =>
      docs.where((doc) => doc.value<dynamic>(fieldName) == fieldValue).toList();
}

class StringContainsFilter extends CollectionFieldFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) => docs
      .where((doc) => doc
          .value<dynamic>(field.name)
          .toString()
          .toLowerCase()
          .contains(field.value.toString().toLowerCase()))
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
      if (doc.value<SQRef>(fieldName) == null) return false;
      final docRef = doc.value<SQRef>(fieldName);
      if (docRef == null) throw Exception('Filtering null docRef');
      return docRef.docId == fieldValue!.docId &&
          docRef.collectionPath == fieldValue!.collectionPath;
    }).toList();
  }
}

class UserFilter extends RefFilter {
  UserFilter(String userFieldName, {SQRef? userRef})
      : super(userFieldName,
            userRef ?? (SQAuth.isSignedIn ? SQAuth.userDoc!.ref : null));
}

class DocRefFieldFilter extends CollectionFieldFilter {
  DocRefFieldFilter({required SQRefField docRefField}) : super(docRefField);

  @override
  SQRefField get field => super.field as SQRefField;

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final fieldValue = field.value;
    if (fieldValue == null)
      throw Exception('Null field value ref in DocRefFieldFilter');

    return docs.where((doc) {
      final docRef = doc.value<SQRef>(field.name);
      if (docRef == null) return false;
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}

class CompareFuncFilter extends CollectionFieldFilter {
  CompareFuncFilter(super.field, {required this.compareFunc});

  bool Function(int) compareFunc;

  @override
  List<SQDoc> filter(List<SQDoc> docs) => docs.where(
        (doc) {
          final comparableValue = doc.value<Comparable<dynamic>>(field.name);
          if (comparableValue == null)
            throw Exception('Comparable value is null in CompareFuncFilter');
          return compareFunc(
            comparableValue.compareTo(field.value),
          );
        },
      ).toList();
}
