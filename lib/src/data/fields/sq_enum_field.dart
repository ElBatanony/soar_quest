import 'package:flutter/material.dart';

import '../../screens/form_screen.dart';
import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'sq_list_field.dart';

class SQEnumField<T> extends SQField<T> {
  SQEnumField(this.subfield, {required this.options, super.value, super.show})
      : super(subfield.name);

  SQField<T> subfield;
  List<T> options;

  @override
  SQEnumField<T> copy() => SQEnumField<T>(subfield.copy(),
      options: copyList<T>(options), value: value, show: show);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQEnumFormField(this, doc, onChanged: onChanged);

  @override
  T? parse(source) => subfield.parse(source);
}

class _SQEnumFormField<T> extends SQFormField<SQEnumField<T>> {
  const _SQEnumFormField(super.field, super.doc, {required super.onChanged});

  @override
  Widget fieldLabel(screenState) => screenState is FormScreenState
      ? super.fieldLabel(screenState)
      : Container();

  @override
  Widget readOnlyBuilder(formFieldState) {
    final subfieldCopy = field.subfield.copy()
      ..value = field.value
      ..editable = false;
    return subfieldCopy.formField(doc);
  }

  @override
  createState() => _SQEnumFormFieldState<T>();
}

class _SQEnumFormFieldState<T> extends SQFormFieldState<SQEnumField<T>> {
  @override
  Widget fieldBuilder(formFieldState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.value.toString()),
          SQButton('Select', onPressed: () async {
            final newValue = await showEnumOptionsDialog(field,
                context: screenState.context);
            if (newValue != null) {
              field.value = newValue;
              setState(() {});
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
                title: Text('Select ${enumField.name} value'),
                content: Wrap(
                  children: [
                    ...enumField.options.map((v) => SQButton(v.toString(),
                        onPressed: () => Navigator.pop<T>(context, v))),
                  ],
                ),
                actions: [
                  SQButton('Cancel', onPressed: () => Navigator.pop(context)),
                ]));
