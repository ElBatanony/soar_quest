import '../fields.dart';

class SQStringField extends SQDocField<String> {
  SQStringField(String name,
      {String value = "", super.readOnly, super.required})
      : super(name, value: value);

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() =>
      SQStringField(name, value: value, readOnly: readOnly, required: required);

  @override
  String get value => super.value ?? "";

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQStringFormField(this, onChanged: onChanged);
  }

  @override
  bool get isNull => value.isEmpty;
}
