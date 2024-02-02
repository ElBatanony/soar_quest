import 'package:collection/collection.dart';

import '../fields/file_field.dart';
import '../fields/image_link_field.dart';
import '../fields/virtual_field.dart';
import 'sq_collection.dart';
import 'types/sq_ref.dart';

export 'sq_condition.dart';
export 'sq_field.dart';

typedef DocData = Map<String, dynamic>;

class SQDoc {
  SQDoc(this.id, {required this.collection}) {
    path = '${collection.path}/$id';

    for (final field in collection.fields) field.init(this);
  }

  final Map<String, dynamic> _values = {};
  final String id;
  SQCollection collection;
  late final String path;

  void parse(Map<String, dynamic> source) {
    for (final field in collection.fields)
      if (source.containsKey(field.name))
        _values[field.name] = field.parse(source[field.name]);
  }

  Map<String, dynamic> serialize() {
    final jsonMap = <String, dynamic>{};
    for (final field in collection.fields) {
      if (field is SQVirtualField) continue;
      jsonMap[field.name] = field.serialize(_values[field.name]);
    }
    return jsonMap;
  }

  T? getValue<T>(String fieldName) => _values[fieldName] as T?;

  void setValue<T>(String fieldName, T value) {
    final field = collection.getField(fieldName);
    if (field != null)
      _values[fieldName] = field.parse(value);
    else
      _values[fieldName] = value;
  }

  String get label =>
      _values[collection.label ?? collection.fields.first.name].toString();

  String? get secondaryLabel {
    final nonImageFields = collection.fields
        .whereNot((field) => field is SQFileField || field is SQVirtualField)
        .toList();
    return nonImageFields.length >= 2
        ? _values[nonImageFields[1].name].toString()
        : null;
  }

  SQRef get ref => SQRef.fromDoc(this);

  @override
  String toString() => label;

  SQImageLinkField? get _imageLabelField => collection.fields
      .whereType<SQImageLinkField>()
      .firstWhereOrNull((field) => _values[field.name] != null);

  String? get imageLabel => _imageLabelField == null
      ? null
      : _values[_imageLabelField?.name] as String?;
}
