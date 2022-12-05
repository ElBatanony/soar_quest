import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import '../types/sq_timestamp.dart';

export '../types/sq_timestamp.dart';

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(super.name, {SQTimestamp? value, super.editable, super.show})
      : super(value: value ?? SQTimestamp.now());

  @override
  SQTimestamp? parse(source) => SQTimestamp.parse(source);

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, editable: editable, show: show);

  @override
  formField(docScreenState) => _SQTimestampFormField(this, docScreenState);
}

class _SQTimestampFormField extends SQFormField<SQTimestampField> {
  const _SQTimestampFormField(super.field, super.docScreenState);

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
  ) =>
      DialogRoute<DateTime>(
        context: context,
        builder: (context) => DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2040),
        ),
      );

  void _selectDate(DateTime? newSelectedDate, SQFormFieldState formFieldState) {
    if (newSelectedDate != null) {
      field.value = SQTimestamp.fromDate(newSelectedDate);
      onChanged();
    }
  }

  @override
  Widget fieldBuilder(formFieldState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.value.toString()),
          SQButton(
            'Select Date',
            onPressed: () async {
              final ret = await Navigator.of(formFieldState.context)
                  .push(_datePickerRoute(
                formFieldState.context,
              ));
              if (ret != null) {
                _selectDate(ret, formFieldState);
              }
            },
          )
        ],
      );
}
