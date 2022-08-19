import 'package:soar_quest/data.dart';

extension FilterDocs on SQCollection {
  List<SQDoc> filter(List<DocsFilter> filters) {
    List<SQDoc> ret = docs;
    for (var filter in filters) {
      ret = filter.filter(ret);
    }
    return ret;
  }
}

class DocsFilter {
  SQDocField field;

  DocsFilter(this.field);

  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => doc.getFieldValueByName(field.name) == field.value)
        .toList();
  }
}

class StringContainsFilter extends DocsFilter {
  StringContainsFilter(super.field);

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    return docs
        .where((doc) => (doc.getFieldValueByName(field.name) as String)
            .contains(field.value))
        .toList();
  }
}
