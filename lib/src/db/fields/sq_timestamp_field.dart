import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'types/sq_timestamp.dart';
import '../../ui/sq_button.dart';

export 'types/sq_timestamp.dart';

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value, super.editable})
      : super(name, value: value ?? SQTimestamp.now());

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, editable: editable);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQTimestampFormField(this, onChanged: onChanged);
  }
}

class _SQTimestampFormField extends SQFormField<SQTimestampField> {
  const _SQTimestampFormField(super.field, {super.onChanged});

  @override
  createState() => _SQTimestampFormFieldState();
}

class _SQTimestampFormFieldState extends SQFormFieldState<SQTimestampField> {
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
  Widget fieldBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
