import 'fields/types/sq_doc_ref.dart';
import 'sq_collection.dart';

export 'sq_doc_field.dart';

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

  Future saveDoc() {
    return collection.saveDoc(this);
  }

  Map<String, dynamic> collectFields() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.collectField();
    }
    return ret;
  }

  SQDocField? getField(String fieldName) {
    return fields.singleWhere((field) => field.name == fieldName);
  }

  dynamic value(String fieldName) {
    return getField(fieldName)?.value;
  }

  void setDocFieldByName(String fieldName, dynamic value) {
    SQDocField? field = getField(fieldName);
    field?.value = value;
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }

  String get identifier => fields.first.value.toString();

  SQDocRef get ref => SQDocRef.fromDoc(this);

  @override
  String toString() => identifier;
}
