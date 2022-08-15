import 'package:cloud_firestore/cloud_firestore.dart';

enum SQDocFieldType { int, string, bool, timestamp }

Map<SQDocFieldType, dynamic> defaultTypeValue = {
  SQDocFieldType.int: 0,
  SQDocFieldType.string: "",
  SQDocFieldType.bool: false,
  SQDocFieldType.timestamp: Timestamp(0, 0)
};

class SQDocField {
  String name;
  SQDocFieldType type;
  dynamic value;
  dynamic defualtValue;

  SQDocField(this.name, this.type, {this.value, this.defualtValue}) {
    defualtValue ??= defaultTypeValue[type];
    value ??= defualtValue;
  }

  static SQDocField unknownField() {
    return SQDocField("Unknown", SQDocFieldType.string);
  }

  SQDocField copy() {
    return SQDocField(name, type, value: value, defualtValue: defualtValue);
  }
}
