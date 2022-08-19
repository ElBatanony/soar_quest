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
  String name;
  SQDocFieldType type;
  dynamic value;

  dynamic get defaultValue => defaultTypeValue[type];

  SQDocField(this.name, this.type, {this.value}) {
    value ??= defaultValue;
  }

  static SQDocField unknownField() {
    return SQDocField("Unknown", SQDocFieldType.string);
  }

  SQDocField copy() {
    return SQDocField(name, type, value: value, defualtValue: defualtValue);
  }
}
