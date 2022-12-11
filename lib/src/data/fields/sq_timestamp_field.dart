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

class _SQTimestampFormField extends SQFormField<SQTimestamp, SQTimestampField> {
  const _SQTimestampFormField(super.field, super.docScreenState);

  static Route<DateTime> _datePickerRoute(
    DateTime initialValue,
    BuildContext context,
  ) =>
      DialogRoute<DateTime>(
        context: context,
        builder: (context) => DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: initialValue,
          firstDate: DateTime(2000),
          lastDate: DateTime(2040),
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
              final newSelectedDate = await Navigator.of(context).push(
                  _datePickerRoute(
                      getDocValue()?.toDate() ?? DateTime.now(), context));
              if (newSelectedDate != null)
                setDocValue(SQTimestamp.fromDate(newSelectedDate));
            },
          )
        ],
      );
}
