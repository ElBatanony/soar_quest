import '../fields.dart';

class SQIntField extends SQDocField<int> {
  SQIntField(super.name, {super.value, super.readOnly});

  @override
  int? parse(source) {
    if (source is int) return source;
    return null;
  }

  @override
  SQIntField copy() => SQIntField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQIntFormField(this, onChanged: onChanged);
  }
}
