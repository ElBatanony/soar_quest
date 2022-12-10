import 'package:collection/collection.dart';

import 'fields/sq_image_field.dart';
import 'sq_collection.dart';
import 'types/sq_ref.dart';

export '../screens/screen.dart' show ScreenState;
export 'sq_condition.dart';
export 'sq_field.dart';

typedef DocData = Map<String, dynamic>;

class SQDoc {
  SQDoc(this.id, {required this.collection}) {
    path = '${collection.path}/$id';

    for (final field in collection.fields) {
      setValue(field.name, field.defaultValue);
    }
  }

  final Map<String, dynamic> _values = {};
  String id;
  SQCollection collection;
  late String path;

  void parse(Map<String, dynamic> source) {
    // TODO: user Map.addAll. values.addAll source maybe
    for (final field in collection.fields)
      if (source.containsKey(field.name))
        _values[field.name] = field.parse(source[field.name]);
  }

  Map<String, dynamic> serialize() {
    final jsonMap = <String, dynamic>{};
    for (final field in collection.fields) {
      jsonMap[field.name] = field.serialize(_values[field.name]);
    }
    return jsonMap;
  }

  T? getValue<T>(String fieldName) => _values[fieldName] as T?;
  void setValue<T>(String fieldName, T value) => _values[fieldName] = value;
  // TODO: add type checking for setting doc value.
  // check collection field with same name

  String get label => _values[collection.fields.first.name].toString();

  String? get secondaryLabel => collection.fields.length >= 2
      ? _values[collection.fields[1].name].toString()
      : null;

  SQRef get ref => SQRef.fromDoc(this);

  @override
  String toString() => label;

  SQImageField? get _imageLabelField => collection.fields
      .whereType<SQImageField>()
      .firstWhereOrNull((field) => _values[field.name] != null);

  String? get imageLabel =>
      _imageLabelField == null ? null : _values[_imageLabelField] as String;
}
