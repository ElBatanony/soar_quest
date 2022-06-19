import 'package:soar_quest/data/sq_collection.dart';

import 'sq_doc_field.dart';
export 'sq_doc_field.dart';

class SQDoc {
  late List<SQDocField> fields;
  String id;
  late SQCollection collection;

  static List<SQDocField> copyFields(List<SQDocField> fields) {
    return fields.map((field) => field.copy()).toList();
  }

  SQDoc(this.id, List<SQDocField> newFields, {required this.collection}) {
    fields = SQDoc.copyFields(newFields);
  }

  setData(Map<String, dynamic> dataToSet) {
    dataToSet.forEach((key, value) {
      fields.firstWhere((element) => element.name == key, orElse: () {
        print("Data field not found");
        return SQDocField.unknownField();
      }).value = value;
    });
  }

  updateDoc() {
    return collection.updateDoc(this);
  }

  Map<String, dynamic> collectFields() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.value;
    }
    return ret;
  }

  SQDocField getFieldByName(String fieldName) {
    return fields.singleWhere((field) => field.name == fieldName);
  }

  dynamic getFieldValueByName(String fieldName) {
    return getFieldByName(fieldName).value;
  }

  Future setDocFieldByName(String fieldName, dynamic value) {
    SQDocField field = getFieldByName(fieldName);
    field.value = value;
    return collection.updateDoc(this);
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }

  String get identifier => fields.first.value;
}
