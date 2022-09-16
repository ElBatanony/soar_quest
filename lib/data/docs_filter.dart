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

class DocValueFilter extends DocsFieldFilter {
  DocValueFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => doc.getFieldValueByName(field.name) == field.value)
        .toList();
  }
}

class StringContainsFilter extends DocsFieldFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => (doc.getFieldValueByName(field.name) as String)
            .contains(field.value))
        .toList();
  }
}

class DocRefFilter extends DocsFieldFilter {
  SQDocReferenceField docRefField;

  DocRefFilter({required this.docRefField}) : super(docRefField);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs.where((doc) {
      if (doc.getFieldValueByName(field.name) == null) return false;

      SQDocReference docRef = doc.getFieldValueByName(field.name);
      SQDocReference fieldValue = field.value;
      return docRef.docId == fieldValue.docId &&
          docRef.collectionPath == fieldValue.collectionPath;
    }).toList();
  }
}
