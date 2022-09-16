import '../db.dart';
import '../types.dart';
export '../fields.dart';

class SQDoc {
  late List<SQDocField> fields;
  String id;
  SQCollection collection;
  bool initialized = false;

  static List<SQDocField> copyFields(List<SQDocField> fields) {
    return fields.map((field) {
      SQDocField fieldCopy = field.copy();
      assert(field.runtimeType == fieldCopy.runtimeType,
          "SQDocField not copied properly");
      return fieldCopy;
    }).toList();
  }

  SQDoc(this.id, {required this.collection}) {
    fields = SQDoc.copyFields(collection.fields);
  }

  Future loadDoc({bool forceFetch = false}) async {
    if (initialized && forceFetch == false) return;
    await collection.loadDoc(this);
  }

  setData(Map<String, dynamic> dataToSet) {
    for (var entry in dataToSet.entries) {
      var key = entry.key;
      var value = entry.value;

      if (fields.any((field) => field.name == key) == false) continue;

      SQDocField field = fields.firstWhere((field) => field.name == key);

      field.value = field.parse(value);
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

  SQDocField? getFieldByName(String fieldName) {
    return fields.singleWhere((field) => field.name == fieldName);
  }

  dynamic getFieldValueByName(String fieldName) {
    return getFieldByName(fieldName)?.value;
  }

  Future setDocFieldByName(String fieldName, dynamic value) {
    SQDocField? field = getFieldByName(fieldName);
    field?.value = value;
    return collection.updateDoc(this);
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }

  String get identifier => fields.first.value.toString();

  SQDocReference get ref => SQDocReference.fromDoc(this);

  @override
  String toString() => identifier;
}
