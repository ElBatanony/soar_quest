import 'package:flutter/material.dart';

import '../components/buttons/sq_button.dart';
import '../../db.dart';

class SQTimestampField extends SQDocField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value, super.readOnly})
      : super(name, value: value ?? SQTimestamp.fromDate(DateTime.now()));

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQTimestampFormField(this, onChanged: onChanged);
  }
}

class _SQTimestampFormField extends DocFormField<SQTimestampField> {
  const _SQTimestampFormField(super.field, {super.onChanged});

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
