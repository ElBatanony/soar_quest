import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/types.dart';
import '../buttons/sq_button.dart';

class SQTimestampFormField extends DocFormField {
  const SQTimestampFormField(super.field,
      {required super.onChanged, super.doc, super.key});

  @override
  State<SQTimestampFormField> createState() => _SQTimestampFormFieldState();
}

class _SQTimestampFormFieldState
    extends DocFormFieldState<SQTimestampFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.field.name),
        Text(widget.field.value.toString()),
        TimestampDocFieldPicker(
            timestampField: widget.field as SQTimestampField,
            updateCallback: onChanged),
      ],
    );
  }
}

class TimestampDocFieldPicker extends StatefulWidget {
  const TimestampDocFieldPicker(
      {Key? key, required this.timestampField, required this.updateCallback})
      : super(key: key);

  final SQTimestampField timestampField;
  final Function updateCallback;

  @override
  State<TimestampDocFieldPicker> createState() =>
      _TimestampDocFieldPickerState();
}

class _TimestampDocFieldPickerState extends State<TimestampDocFieldPicker> {
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2040),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      widget.timestampField.value = SQTimestamp.fromDate(newSelectedDate);
      widget.updateCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SQButton(
      'Select Date',
      onPressed: () async {
        DateTime? ret = await Navigator.of(context).push(_datePickerRoute(
          context,
        ));
        if (ret != null) {
          _selectDate(ret);
        }
      },
    );
  }
}
