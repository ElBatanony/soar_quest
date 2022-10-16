import 'package:collection/collection.dart';

import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';
import '../storage/sq_image_field.dart';

export 'sq_field.dart';

class SQDoc {
  late List<SQField<dynamic>> fields;
  String id;
  SQCollection collection;
  bool initialized = false;
  late String path;

  SQDoc(this.id, {required this.collection}) {
    path = "${collection.path}/$id";

    fields = collection.fields.map((field) {
      SQField<dynamic> fieldCopy = field.copy();
      assert(field.runtimeType == fieldCopy.runtimeType,
          "SQField not copied properly (${field.runtimeType} vs. ${fieldCopy.runtimeType})");
      return fieldCopy;
    }).toList();
  }

  void parse(Map<String, dynamic> source) {
    for (var field in fields) field.value = field.parse(source[field.name]);
    initialized = true;
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.serialize();
    }
    return ret;
  }

  F? getField<F extends SQField<dynamic>>(String fieldName) {
    return fields.singleWhereOrNull(
        (field) => field.name == fieldName && field is F) as F?;
  }

  T? value<T>(String fieldName) {
    return getField<SQField<T>>(fieldName)?.value;
  }

  String get label => fields.first.value.toString();

  SQRef get ref => SQRef.fromDoc(this);

  @override
  String toString() => label;

  SQImageField? get imageLabel => fields
      .whereType<SQImageField>()
      .firstWhereOrNull((field) => field.value != null);
}
