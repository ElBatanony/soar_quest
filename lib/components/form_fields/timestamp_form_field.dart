import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/types.dart';
import '../buttons/sq_button.dart';

class SQTimestampFormField extends DocFormField<SQTimestampField> {
  const SQTimestampFormField(super.field,
      {super.onChanged, super.doc, super.key});

  @override
  createState() => _SQTimestampFormFieldState();
}

class _SQTimestampFormFieldState extends DocFormFieldState<SQTimestampField> {
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
      field.value = SQTimestamp.fromDate(newSelectedDate);
      onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        Text(field.value.toString()),
        SQButton(
          'Select Date',
          onPressed: () async {
            DateTime? ret = await Navigator.of(context).push(_datePickerRoute(
              context,
            ));
            if (ret != null) {
              _selectDate(ret);
            }
          },
        )
      ],
    );
  }
}
