import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../ui/button.dart';
import '../sq_field.dart';

class SQColorField extends SQField<Color> {
  SQColorField(super.name, {super.defaultValue});

  @override
  formField(docScreen) => _SQColorFormField(this, docScreen);

  @override
  Color? parse(source) {
    if (source is int) return Color(source);
    return super.parse(source);
  }

  @override
  int? serialize(value) {
    if (value == null) return null;
    return value.value;
  }

  @override
  valueDisplay(value) =>
      Container(width: 30, height: 30, color: value ?? Colors.white);
}

class _SQColorFormField extends SQFormField<Color, SQColorField> {
  const _SQColorFormField(super.field, super.docScreen);

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
            widget.formField.field.valueDisplay(widget.formField.getDocValue()),
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
