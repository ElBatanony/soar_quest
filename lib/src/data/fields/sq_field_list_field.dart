import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'sq_list_field.dart';

class SQFieldListField<T> extends SQListField<SQField<T>> {
  SQFieldListField(super.name, this.field, {super.value});

  SQField<T> field;

  List<SQField<T>> get fields => value ?? [];

  @override
  List<SQField<T>> parse(dynamic source) {
    final dynamicList = (source ?? <dynamic>[]) as List;
    final fields = <SQField<T>>[];
    for (final dynamicFieldValue in dynamicList) {
      final newField = field.copy();
      final parsed = newField.parse(dynamicFieldValue);

      if (parsed != null && parsed.runtimeType == field.value.runtimeType) {
        newField.value = parsed;
        fields.add(newField);
        break;
      }
    }
    return fields;
  }

  @override
  SQFieldListField<T> copy() =>
      SQFieldListField(name, field, value: copyList(fields));

  @override
  List<dynamic> serialize() =>
      fields.map((field) => field.serialize()).toList();

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQFieldListFormField(this, doc, onChanged: onChanged);
}

class _SQFieldListFormField<T> extends SQFormField<SQFieldListField<T>> {
  const _SQFieldListFormField(super.field, super.doc, {super.onChanged});

  @override
  String get fieldLabelText => '${field.name} (${field.fields.length} items)';

  @override
  Widget readOnlyBuilder(formFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final field in field.fields)
            (field..isInline = true).formField(doc),
        ],
      );

  @override
  createState() => _SQFieldListFormFieldState();
}

class _SQFieldListFormFieldState<T>
    extends SQFormFieldState<SQFieldListField<T>> {
  SQFieldListField<T> get listField => field;

  void addField() {
    final newField = listField.field.copy();
    setState(() {
      listField.fields.add(newField);
    });
  }

  @override
  Widget fieldBuilder(formFieldState) => Column(
        children: [
          for (final field in listField.fields)
            Row(
              children: [
                Expanded(child: (field..isInline = true).formField(doc)),
                SQButton.icon(
                  Icons.delete,
                  onPressed: () => listField.fields.remove(field),
                ),
              ],
            ),
          SQButton.icon(Icons.add, text: 'Insert Item', onPressed: addField),
        ],
      );
}
