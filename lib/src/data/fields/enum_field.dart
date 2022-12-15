import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';

class SQEnumField<T> extends SQField<T> {
  SQEnumField(this.subfield, {required this.options, super.show})
      : super(subfield.name, defaultValue: subfield.defaultValue) {
    subfield
      ..editable = false
      ..isInline = true;
  }

  SQField<T> subfield;
  List<T> options;

  @override
  formField(docScreenState) => _SQEnumFormField(this, docScreenState);

  @override
  T? parse(source) => subfield.parse(source) ?? super.parse(source);

  @override
  serialize(value) => subfield.serialize(value);
}

class _SQEnumFormField<T> extends SQFormField<T, SQEnumField<T>> {
  const _SQEnumFormField(super.field, super.docScreenState);

  @override
  Widget readOnlyBuilder(context) => field.subfield.formField(docScreenState);

  @override
  fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          field.subfield.valueDisplay(getDocValue()),
          SQButton('Select', onPressed: () async {
            final newValue =
                await showEnumOptionsDialog(field, context: context);
            if (newValue != null) {
              setDocValue(newValue);
            }
          })
        ],
      );
}

Future<T?> showEnumOptionsDialog<T>(SQEnumField<T> enumField,
        {required BuildContext context}) =>
    showDialog<T?>(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Select ${enumField.name}'),
                content: Wrap(
                  children: [
                    ...enumField.options.map((v) => ElevatedButton(
                        child: enumField.subfield.valueDisplay(v),
                        onPressed: () => Navigator.pop<T>(context, v))),
                  ],
                ),
                actions: [
                  SQButton('Cancel', onPressed: () => Navigator.pop(context)),
                ]));
