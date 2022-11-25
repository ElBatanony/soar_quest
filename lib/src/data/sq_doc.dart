import 'package:collection/collection.dart';

import '../storage/sq_image_field.dart';
import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';

export '../screens/screen.dart' show ScreenState;
export 'sq_condition.dart';
export 'sq_field.dart';

class SQDoc {
  late List<SQField<dynamic>> fields;
  String id;
  SQCollection collection;
  late String path;

  SQDoc(this.id, {required this.collection}) {
    path = '${collection.path}/$id';

    fields = collection.fields.map((field) {
      final fieldCopy = field.copy();
      assert(
        field.runtimeType == fieldCopy.runtimeType &&
            field.name == fieldCopy.name &&
            field.editable == fieldCopy.editable &&
            field.require == fieldCopy.require,
        'Incorrect SQField copy operation ${field.runtimeType}',
      );
      return fieldCopy;
    }).toList();
  }

  void parse(Map<String, dynamic> source) {
    for (final field in fields) field.value = field.parse(source[field.name]);
  }

  Map<String, dynamic> serialize() {
    final jsonMap = <String, dynamic>{};
    for (final field in fields) {
      jsonMap[field.name] = field.serialize();
    }
    return jsonMap;
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

  List<SQField<dynamic>> copyFields() =>
      fields.map((field) => field.copy()).toList();
}
