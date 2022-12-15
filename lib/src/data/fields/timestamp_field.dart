import 'package:flutter/material.dart';

import '../../ui/button.dart';
import '../sq_doc.dart';
import '../types/sq_timestamp.dart';

export '../types/sq_timestamp.dart';

final defaultFirstDate = DateTime(1900);
final defaultLastDate = DateTime(2040);

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(
    super.name, {
    SQTimestamp? defaultValue,
    super.editable,
    super.show,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : firstDate = firstDate ?? defaultFirstDate,
        lastDate = lastDate ?? defaultLastDate,
        super(defaultValue: defaultValue ?? SQTimestamp.now());

  final DateTime firstDate, lastDate;

  @override
  SQTimestamp? parse(source) =>
      SQTimestamp.parse(source) ?? super.parse(source);

  @override
  formField(docScreenState) => _SQTimestampFormField(this, docScreenState);
}

class _SQTimestampFormField extends SQFormField<SQTimestamp, SQTimestampField> {
  const _SQTimestampFormField(super.field, super.docScreenState);

  Route<DateTime> _datePickerRoute(BuildContext context) =>
      DialogRoute<DateTime>(
        context: context,
        builder: (context) => DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: getDocValue()?.toDate() ?? DateTime.now(),
          firstDate: field.firstDate,
          lastDate: field.lastDate,
        ),
      );

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(doc.getValue<dynamic>(field.name).toString()),
          SQButton(
            'Select Date',
            padding: 0,
            onPressed: () async {
              final newSelectedDate =
                  await Navigator.of(context).push(_datePickerRoute(context));
              if (newSelectedDate != null)
                setDocValue(SQTimestamp.fromDate(newSelectedDate));
            },
          )
        ],
      );
}
