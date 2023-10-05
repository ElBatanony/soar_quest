import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../data/types/sq_timestamp.dart';
import '../ui/button.dart';

export '../data/types/sq_timestamp.dart';

final defaultFirstDate = DateTime(1900);
final defaultLastDate = DateTime(2040);

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(
    super.name, {
    DateTime? firstDate,
    DateTime? lastDate,
  })  : firstDate = firstDate ?? defaultFirstDate,
        lastDate = lastDate ?? defaultLastDate {
    defaultValue = SQTimestamp.now();
  }

  final DateTime firstDate, lastDate;

  @override
  SQTimestamp? parse(source) =>
      SQTimestamp.parse(source) ?? super.parse(source);

  @override
  serialize(SQTimestamp? value) => value?.toJson();

  @override
  formField(docScreen) => _SQTimestampFormField(this, docScreen);
}

class _SQTimestampFormField extends SQFormField<SQTimestamp, SQTimestampField> {
  const _SQTimestampFormField(super.field, super.docScreen);

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
