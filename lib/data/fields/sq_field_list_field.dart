import '../fields.dart';

class SQFieldListField extends SQDocField<List<SQDocField>> {
  List<Type> allowedTypes;

  SQFieldListField(String name,
      {List<SQDocField> value = const <SQDocField>[],
      required this.allowedTypes})
      : super(name, value: value);

  @override
  Type get type => List;

  @override
  List<SQDocField> get value => super.value ?? [];

  SQDocField fromDynamic(dynamicValue, {String name = ""}) {
    switch (dynamicValue.runtimeType) {
      case String:
        return SQStringField(name, value: dynamicValue);
      case bool:
        return SQBoolField(name, value: dynamicValue);
      // case Timestamp:
      //   return SQTimestampField(name,
      //       value: SQTimestamp.fromTimestamp(dynamicValue));
      // case List: TODO: bring back from dyamic SQDocListField, needs list of types
      //   return SQDocListField(name, value: dynamicValue);
      default:
        throw UnimplementedError(
            "Dynamic SQDocField type of field not expexted");
    }
  }

  @override
  List<SQDocField> parse(source) {
    List<SQDocField> sqFields = [];
    for (var dynField in (source as List)) {
      sqFields.add(fromDynamic(dynField));
    }
    return value = sqFields;
  }

  @override
  SQFieldListField copy() => SQFieldListField(name,
      value: value.map((e) => e.copy()).toList(), allowedTypes: allowedTypes);

  @override
  List<dynamic> collectField() {
    return value.map((listItemField) => listItemField.collectField()).toList();
  }
}
