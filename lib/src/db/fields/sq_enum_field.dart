import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'sq_list_field.dart';

class SQEnumField<T> extends SQField<T> {
  SQField<T> subfield;
  List<T> options;

  SQEnumField(this.subfield, {required this.options, super.value})
      : super(subfield.name);

  @override
  SQEnumField<T> copy() {
    return SQEnumField<T>(subfield.copy(),
        options: copyList<T>(options), value: value);
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) =>
      _SQEnumFormField(this, onChanged: onChanged);

  @override
  T? parse(source) => subfield.parse(source);
}

class _SQEnumFormField<T> extends SQFormField<SQEnumField<T>> {
  const _SQEnumFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQEnumFormFieldState<T>();
}

class _SQEnumFormFieldState<T> extends SQFormFieldState<SQEnumField<T>> {
  @override
  Widget readOnlyBuilder(BuildContext context) {
    SQField<T> subfieldCopy = field.subfield.copy();
    subfieldCopy.value = field.value;
    subfieldCopy.editable = false;
    return subfieldCopy.formField();
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return Row(
      children: [
        Text(field.value.toString()),
        SQButton("Select", onPressed: () async {
          T? newValue = await showEnumOptionsDialog(field, context: context);
          if (newValue != null) {
            field.value = newValue;
            setState(() {});
          }
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (field.editable == false) return readOnlyBuilder(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [fieldLabel(), SizedBox(height: 4), fieldBuilder(context)],
      ),
    );
  }
}

Future<T?> showEnumOptionsDialog<T>(SQEnumField<T> enumField,
    {required BuildContext context}) {
  return showDialog<T?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Select ${enumField.name} value"),
            content: Wrap(
              children: [
                ...enumField.options
                    .map((v) => SQButton(v.toString(),
                        onPressed: () => Navigator.pop<T>(context, v)))
                    .toList(),
              ],
            ),
            actions: [
              SQButton('Cancel', onPressed: () => Navigator.pop(context)),
            ]);
      });
}
