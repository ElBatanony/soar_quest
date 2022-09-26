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

  @override
  List<SQDocField> parse(source) {
    List<dynamic> dynamicList = source as List;
    List<SQDocField> fields = [];
    for (var dynamicFieldValue in dynamicList) {
      for (SQDocField allowedType in allowedTypes) {
        var parsed = allowedType.parse(dynamicFieldValue);

        if (parsed != null && parsed.runtimeType == allowedType.type) {
          SQDocField newField = allowedType.copy();
          newField.value = parsed;
          fields.add(newField);
          break;
        }
      }
    }
    return fields;
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
