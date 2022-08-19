import 'package:soar_quest/data/sq_doc.dart';

import 'sq_timestamp.dart';
export 'sq_timestamp.dart' show SQTimestamp;

enum SQDocFieldType { int, string, bool, timestamp, list, nullType }

Map<SQDocFieldType, dynamic> defaultTypeValue = {
  SQDocFieldType.int: 0,
  SQDocFieldType.string: "",
  SQDocFieldType.bool: false,
  SQDocFieldType.timestamp: SQTimestamp(0, 0),
  SQDocFieldType.list: <SQDocField>[],
  SQDocFieldType.nullType: null
};

class SQDocField {
  String name = "";
  SQDocFieldType type;
  dynamic value;

  dynamic get defaultValue => defaultTypeValue[type];

  SQDocField(this.name, this.type, {this.value}) {
    value ??= defaultValue;
  }

  SQDocField.nameless(this.type);

  static SQDocField unknownField() {
    return SQDocField("Unknown", SQDocFieldType.string);
  }

  SQDocField copy() {
    return SQDocField(name, type, value: value);
  }

  dynamic collectField() => value;
}

class SQDocListField extends SQDocField {
  SQDocListField(String name, {List<SQDocField> value = const <SQDocField>[]})
      : super(name, SQDocFieldType.list, value: value);

  @override
  List<SQDocField> get value => super.value as List<SQDocField>;

  @override
  SQDocField copy() {
    return SQDocListField(name, value: [...value]);
  }

  @override
  List<dynamic> collectField() {
    return value.map((listItemField) => listItemField.collectField()).toList();
  }
}
