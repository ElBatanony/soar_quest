import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../ui/button.dart';

class SQEnumField<T> extends SQField<T> {
  SQEnumField(
    this.subfield, {
    required this.options,
    this.isDropdown = false,
  }) : super(subfield.name) {
    defaultValue = subfield.defaultValue;
    subfield
      ..editable = false
      ..isInline = true;
  }

  SQField<T> subfield;
  List<T> options;
  bool isDropdown;

  @override
  formField(docScreen) => _SQEnumFormField(this, docScreen);

  @override
  T? parse(source) => subfield.parse(source) ?? super.parse(source);

  @override
  serialize(value) => subfield.serialize(value);
}

class _SQEnumFormField<T> extends SQFormField<T, SQEnumField<T>> {
  const _SQEnumFormField(super.field, super.docScreen);

  @override
  Widget readOnlyBuilder(context) => field.subfield.formField(docScreen);

  @override
  fieldBuilder(context) => field.isDropdown
      ? dropdownMenuField()
      : Row(
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

  Widget dropdownMenuField() => DropdownButton<T>(
      value: getDocValue(),
      items: field.options
          .map((option) => DropdownMenuItem<T>(
              value: option, child: field.subfield.valueDisplay(option)))
          .toList(),
      onChanged: setDocValue);
}

Future<T?> showEnumOptionsDialog<T>(SQEnumField<T> enumField,
        {required BuildContext context}) =>
    showDialog<T?>(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Select ${enumField.name}'),
                content: Wrap(
                  children: [
                    ...enumField.options.map(
                      (v) => Padding(
                        padding: const EdgeInsets.all(3),
                        child: ElevatedButton(
                            child: enumField.subfield.valueDisplay(v),
                            onPressed: () => Navigator.pop<T>(context, v)),
                      ),
                    ),
                  ],
                ),
                actions: [
                  SQButton('Cancel', onPressed: () => Navigator.pop(context)),
                ]));
