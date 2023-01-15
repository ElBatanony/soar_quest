import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../ui/button.dart';

class SQFieldListField<T> extends SQField<List<T>> {
  SQFieldListField(this.field) : super(field.name) {
    field
      ..name += '_field'
      ..isInline = true;
  }

  SQField<T> field;

  @override
  List<T>? parse(dynamic source) {
    if (source is! List) return null;
    return super.parse(source) ??
        source.map(field.parse).whereType<T>().toList();
  }

  @override
  serialize(value) {
    if (value == null) return null;
    return value.map((v) => field.serialize(v)).toList();
  }

  @override
  formField(docScreen) => _SQFieldListFormField(this, docScreen);
}

class _SQFieldListFormField<T>
    extends SQFormField<List<T>, SQFieldListField<T>> {
  _SQFieldListFormField(super.field, super.docScreen) {
    subfieldFormField = field.field.formField(docScreen);
  }

  SQFieldListField<T> get listField => field;

  late final SQFormField<T, SQField<T>> subfieldFormField;

  @override
  List<T> getDocValue() => super.getDocValue() ?? <T>[];

  @override
  String get fieldLabelText =>
      '${super.fieldLabelText} (${getDocValue().length} items)';

  @override
  Widget readOnlyBuilder(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final v in getDocValue()) Text(v.toString()),
        ],
      );

  void addField(context) {
    final list = getDocValue();
    final v = doc.getValue<T>(field.field.name);
    if (v != null) {
      list.add(v);
      subfieldFormField.clearDocValue();
      setDocValue(list);
    }
  }

  void removeValue(T v) {
    setDocValue(getDocValue()..remove(v));
  }

  @override
  Widget fieldBuilder(context) => Column(
        children: [
          for (final v in getDocValue())
            if (v != null)
              Row(
                children: [
                  Expanded(child: Text(v.toString())),
                  SQButton.icon(
                    Icons.delete,
                    onPressed: () => removeValue(v),
                  ),
                ],
              ),
          subfieldFormField,
          SQButton.icon(Icons.add,
              text: 'Insert Item', onPressed: () => addField(context)),
        ],
      );
}
