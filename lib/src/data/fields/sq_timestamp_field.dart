import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import '../types/sq_timestamp.dart';

export '../types/sq_timestamp.dart';

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(super.name,
      {SQTimestamp? defaultValue, super.editable, super.show})
      : super(defaultValue: defaultValue ?? SQTimestamp.now());

  @override
  SQTimestamp? parse(source) => SQTimestamp.parse(source);

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

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      field.value = SQTimestamp.fromDate(newSelectedDate);
      onChanged();
    }
  }

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.value.toString()),
          SQButton(
            'Select Date',
            onPressed: () async {
              final ret = await Navigator.of(context).push(_datePickerRoute(
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
