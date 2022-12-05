import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../screens/doc_screen.dart';
import '../../ui/sq_button.dart';
import '../sq_field.dart';

class SQColorField extends SQField<Color> {
  SQColorField(super.name, {super.value});

  @override
  SQField<Color> copy() => SQColorField(name, value: value);

  @override
  formField(DocScreenState<DocScreen> docScreenState) =>
      _SQColorFormField(this, docScreenState);

  @override
  Color? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    try {
      final a = source['a'] as int;
      final r = source['r'] as int;
      final g = source['g'] as int;
      final b = source['b'] as int;
      return Color.fromARGB(a, r, g, b);
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  serialize() {
    final color = value;
    if (color == null) return null;
    return {
      'a': color.alpha,
      'r': color.red,
      'g': color.green,
      'b': color.blue,
    };
  }
}

class _SQColorFormField extends SQFormField<SQColorField> {
  const _SQColorFormField(super.field, super.docScreenState);

  @override
  createState() => _SQColorFormFieldState();

  @override
  Widget fieldBuilder(formFieldState) {
    final fieldState = formFieldState as _SQColorFormFieldState;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (field.value != null)
          Container(height: 30, width: 30, color: field.value),
        SQButton('Set Color', onPressed: () async {
          fieldState.pickerColor = field.value ?? Colors.white;
          await showDialog<void>(
            context: formFieldState.context,
            builder: (context) => AlertDialog(
              title: Text(field.name),
              content: ColorPicker(
                pickerColor: fieldState.pickerColor,
                onColorChanged: (newPicker) {
                  fieldState.pickerColor = newPicker;
                },
              ),
              actions: [
                SQButton('Cancel',
                    onPressed: () => Navigator.of(context).pop()),
                SQButton(
                  'Save',
                  onPressed: () {
                    field.value = fieldState.pickerColor;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          onChanged();
        })
      ],
    );
  }
}

class _SQColorFormFieldState extends SQFormFieldState<SQColorField> {
  var pickerColor = Colors.white;
}
