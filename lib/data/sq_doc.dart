import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/data/sq_collection.dart';

import 'sq_doc_field.dart';
export 'sq_doc_field.dart';

class SQDoc {
  late List<SQDocField> fields;
  String id;
  late SQCollection collection;
  bool initialized = false;

  static List<SQDocField> copyFields(List<SQDocField> fields) {
    return fields.map((field) => field.copy()).toList();
  }

  SQDoc(this.id, List<SQDocField> newFields, {required this.collection}) {
    fields = SQDoc.copyFields(newFields);
  }

  loadDoc() {
    return collection.loadDoc(this);
  }

  setData(Map<String, dynamic> dataToSet) {
    for (var entry in dataToSet.entries) {
      var key = entry.key;
      var value = entry.value;

      bool fieldNotFound = false;
      SQDocField field =
          fields.firstWhere((element) => element.name == key, orElse: () {
        fieldNotFound = true;
        return SQDocField.unknownField();
      });

      if (fieldNotFound) continue;
      field.value = value;
      if (field.type == SQDocFieldType.timestamp) {
        if (field.value.runtimeType == Timestamp)
          field.value = SQTimestamp.fromTimestamp(value);
        else if (field.value["_seconds"] != null)
          field.value = SQTimestamp(field.value["_seconds"], 0);
        else
          throw UnimplementedError("Timestamp variant not handled properly");
      }
    }
    initialized = true;
  }

  updateDoc() {
    return collection.updateDoc(this);
  }

  Map<String, dynamic> collectFields() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.collectField();
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
