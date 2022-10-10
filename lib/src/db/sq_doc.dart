import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';
import '../storage/sq_image_field.dart';

export 'sq_field.dart';

class SQDoc {
  late List<SQField> fields;
  String id;
  SQCollection collection;
  bool initialized = false;
  late String path;

  static List<SQField> copyFields(List<SQField> fields) {
    return fields.map((field) {
      SQField fieldCopy = field.copy();
      assert(field.runtimeType == fieldCopy.runtimeType,
          "SQDocField not copied properly (${field.runtimeType} vs. ${fieldCopy.runtimeType})");
      return fieldCopy;
    }).toList();
  }

  SQDoc(this.id, {required this.collection}) {
    path = "${collection.path}/$id";
    fields = SQDoc.copyFields(collection.fields);
  }

  setData(Map<String, dynamic> dataToSet) {
    for (var entry in dataToSet.entries) {
      var key = entry.key;
      var value = entry.value;

      if (fields.any((field) => field.name == key) == false) continue;

      SQField field = fields.singleWhere((field) => field.name == key);

      field.value = field.parse(value);
    }
    initialized = true;
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.serialize();
    }
    return ret;
  }

  T getField<T extends SQField>(String fieldName) {
    return fields
        .whereType<T>()
        .singleWhere((field) => field.name == fieldName);
  }

  T? value<T>(String fieldName) {
    return getField(fieldName).value;
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
