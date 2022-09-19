import '../fields.dart';

// TODO: create SQDoubleField

class SQIntField extends SQDocField<int> {
  SQIntField(super.name, {super.value, super.readOnly});

  @override
  int? parse(source) {
    if (source is int) value = source;
    return null;
  }

  @override
  SQIntField copy() => SQIntField(name, value: value, readOnly: readOnly);
}
