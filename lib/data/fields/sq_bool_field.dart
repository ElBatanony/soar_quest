import '../fields.dart';

class SQBoolField extends SQDocField<bool> {
  SQBoolField(super.name, {super.value, super.readOnly});

  @override
  bool? parse(source) {
    if (source is bool) return source;
    return null;
  }

  @override
  SQBoolField copy() => SQBoolField(name, value: value, readOnly: readOnly);

  @override
  bool get value => super.value ?? false;
}
