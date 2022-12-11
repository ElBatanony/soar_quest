import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../screens/doc_screen.dart';
import '../../ui/sq_button.dart';
import '../sq_field.dart';

class SQColorField extends SQField<Color> {
  SQColorField(super.name, {super.defaultValue});

  @override
  formField(DocScreenState<DocScreen> docScreenState) =>
      _SQColorFormField(this, docScreenState);

  @override
  Color? parse(source) {
    if (source is Color) return source;
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
  serialize(value) {
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

class _SQColorFormField extends SQFormField<Color, SQColorField> {
  const _SQColorFormField(super.field, super.docScreenState);

  @override
  fieldBuilder(context) => _SQColorPicker(this);
}

class _SQColorPicker extends StatefulWidget {
  const _SQColorPicker(this.formField);

  final _SQColorFormField formField;

  @override
  State<_SQColorPicker> createState() => _SQColorPickerState();
}

class _SQColorPickerState extends State<_SQColorPicker> {
  var pickerColor = Colors.white;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (widget.formField.getDocValue() != null)
            Container(
                height: 30, width: 30, color: widget.formField.getDocValue()),
          SQButton('Set Color', onPressed: () async {
            pickerColor = widget.formField.getDocValue() ?? Colors.white;
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(widget.formField.field.name),
                content: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (newPicker) {
                    pickerColor = newPicker;
                  },
                ),
                actions: [
                  SQButton('Cancel',
                      onPressed: () => Navigator.of(context).pop()),
                  SQButton(
                    'Save',
                    onPressed: () {
                      widget.formField.setDocValue(pickerColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            setState(() {});
          })
        ],
      );
}
