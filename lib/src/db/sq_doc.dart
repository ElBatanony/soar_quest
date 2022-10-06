import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';
import '../storage/sq_image_field.dart';

export 'sq_doc_field.dart';

class SQDoc {
  late List<SQField> fields;
  String id;
  SQCollection collection;
  bool initialized = false;

  static List<SQField> copyFields(List<SQField> fields) {
    return fields.map((field) {
      SQField fieldCopy = field.copy();
      assert(field.runtimeType == fieldCopy.runtimeType,
          "SQDocField not copied properly (${field.runtimeType} vs. ${fieldCopy.runtimeType})");
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

      SQField field = fields.firstWhere((field) => field.name == key);

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

  SQField? getField(String fieldName) {
    if (fields.any((field) => field.name == fieldName))
      return fields.singleWhere((field) => field.name == fieldName);
    return null;
  }

  dynamic value(String fieldName) {
    return getField(fieldName)?.value;
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }

  String get label => fields.first.value.toString();

  SQRef get ref => SQRef.fromDoc(this);

  @override
  String toString() => label;

  bool get hasImage =>
      fields.any((field) => field is SQImageField && field.value != null);

  SQImageField get imageLabel =>
      fields.firstWhere((field) => field is SQImageField && field.value != null)
          as SQImageField;
}
