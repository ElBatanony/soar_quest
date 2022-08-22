import '../data.dart';

class SQDocListField extends SQDocField<List<SQDocField>> {
  SQDocListField(String name, {List<SQDocField> value = const <SQDocField>[]})
      : super(name, value: value);

  @override
  Type get type => List;

  @override
  SQDocField copy() {
    return SQDocListField(name, value: [...value]);
  }

  @override
  List<dynamic> collectField() {
    return value.map((listItemField) => listItemField.collectField()).toList();
  }
}
