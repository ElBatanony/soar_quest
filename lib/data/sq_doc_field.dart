enum SQDocFieldType { int, string, bool }

const Map<SQDocFieldType, dynamic> defaultTypeValue = {
  SQDocFieldType.int: 0,
  SQDocFieldType.string: "",
  SQDocFieldType.bool: false
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
