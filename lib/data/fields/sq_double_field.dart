import '../fields.dart';

class SQDoubleField extends SQDocField<double> {
  SQDoubleField(super.name, {super.value, super.readOnly});

  @override
  double? parse(source) {
    if (source is double) return source;
    if (source is int) return source.toDouble();
    return null;
  }

  @override
  SQDoubleField copy() => SQDoubleField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQDoubleFormField(this, onChanged: onChanged);
  }
}
