import '../fields.dart';

class SQFieldListField extends SQListField<SQDocField> {
  List<SQDocField> allowedTypes;

  SQFieldListField(super.name,
      {List<SQDocField> list = const <SQDocField>[],
      required this.allowedTypes})
      : super(list: list);

  @override
  Type get type => List;

  List<SQDocField> get fields => list;

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
      list: fields.map((e) => e.copy()).toList(), allowedTypes: allowedTypes);

  @override
  List<dynamic> collectField() {
    return fields.map((listItemField) => listItemField.collectField()).toList();
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQFieldListFormField(this, onChanged: onChanged);
  }
}
