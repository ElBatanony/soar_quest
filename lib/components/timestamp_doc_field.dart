import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc_field.dart';

class TimestampDocFieldPicker extends StatefulWidget {
  const TimestampDocFieldPicker(
      {Key? key, required this.timestampField, required this.updateCallback})
      : super(key: key);

  final SQDocField timestampField;
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
    return ElevatedButton(
      onPressed: () async {
        DateTime? ret = await Navigator.of(context).push(_datePickerRoute(
          context,
        ));
        if (ret != null) {
          _selectDate(ret);
        }
      },
      child: const Text('Select Date'),
    );
  }
}
