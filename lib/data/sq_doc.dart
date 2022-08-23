import '../data.dart';
export 'sq_doc_field.dart';
export 'sq_doc_reference.dart';

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

  Future loadDoc({bool forceFetch = false}) async {
    if (initialized && forceFetch == false) return;
    await collection.loadDoc(this);
  }

  setData(Map<String, dynamic> dataToSet) {
    for (var entry in dataToSet.entries) {
      var key = entry.key;
      var value = entry.value;

      bool fieldNotFound = false;
      SQDocField field =
          fields.firstWhere((element) => element.name == key, orElse: () {
        fieldNotFound = true;
        return fields.first;
      });

      if (fieldNotFound) continue;

      if (field.type == SQTimestamp) {
        field.value = SQTimestamp.parse(value);
        continue;
      }

      if (field.type == List) {
        List<SQDocField> sqFields = [];
        for (var dynField in (value as List)) {
          sqFields.add(SQDocField.fromDynamic(dynField));
        }
        field.value = sqFields;
        continue;
      }

      if (field.type == SQDocReference) {
        field.value = SQDocReference.parse(value);
        continue;
      }

      field.value = value;
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
