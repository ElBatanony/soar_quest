import '../fields.dart';
import '../types.dart';

class SQFileField extends SQDocField<SQFile> {
  SQFileField(super.name, {super.value});

  @override
  SQFileField copy() {
    return SQFileField(name, value: value);
  }

  @override
  Type get type => SQFile;

  @override
  SQFile? parse(source) {
    return SQFile.parse(source);
  }

  @override
  SQFile get value => super.value ?? SQFile(fieldName: name, exists: false);

  SQFile get sqFile => value;

  @override
  collectField() {
    return {"exists": value.exists, "fieldName": name};
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQFileFormField(this, onChanged: onChanged, doc: doc);
  }
}
