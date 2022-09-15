import '../fields.dart';

class SQDocListField extends SQDocField<List<SQDocField>> {
  List<Type> allowedTypes;

  SQDocListField(String name,
      {List<SQDocField> value = const <SQDocField>[],
      required this.allowedTypes})
      : super(name, value: value);

  @override
  Type get type => List;

  @override
  List<SQDocField> get value => super.value ?? [];

  @override
  SQDocListField copy() => SQDocListField(name,
      value: value.map((e) => e.copy()).toList(), allowedTypes: allowedTypes);

  @override
  List<dynamic> collectField() {
    return value.map((listItemField) => listItemField.collectField()).toList();
  }
}
