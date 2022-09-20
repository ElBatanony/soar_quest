import 'db.dart';
import 'types/sq_doc_reference.dart';

extension FilterDocs on SQCollection {
  List<SQDoc> filter(List<DocsFilter> filters) {
    List<SQDoc> ret = docs;
    for (var filter in filters) {
      ret = filter.filter(ret);
    }
    return ret;
  }
}

abstract class DocsFilter {
  List<SQDoc> filter(List<SQDoc> docs);
}

abstract class DocsFieldFilter extends DocsFilter {
  SQDocField field;
  DocsFieldFilter(this.field);
}

class DocValueFilter extends DocsFilter {
  String fieldName;
  dynamic fieldValue;
  DocValueFilter(this.fieldName, this.fieldValue);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => doc.getFieldValueByName(fieldName) == fieldValue)
        .toList();
  }
}

class StringContainsFilter extends DocsFieldFilter {
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

class DocRefFilter extends DocsFilter {
  String fieldName;
  dynamic fieldValue;

  DocRefFilter(this.fieldName, this.fieldValue);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs.where((doc) {
      if (doc.getFieldValueByName(fieldName) == null) return false;
      SQDocRef docRef = doc.getFieldValueByName(fieldName);
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}

class DocRefFieldFilter extends DocsFieldFilter {
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
