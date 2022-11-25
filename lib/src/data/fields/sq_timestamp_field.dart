import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'types/sq_timestamp.dart';

export 'types/sq_timestamp.dart';

class SQTimestampField extends SQField<SQTimestamp> {
  SQTimestampField(String name,
      {SQTimestamp? value, super.editable, super.show})
      : super(name, value: value ?? SQTimestamp.now());

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, editable: editable, show: show);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) {
    return _SQTimestampFormField(this, doc, onChanged: onChanged);
  }
}

class _SQTimestampFormField extends SQFormField<SQTimestampField> {
  const _SQTimestampFormField(super.field, super.doc, {super.onChanged});

  @override
  createState() => _SQTimestampFormFieldState();
}

class _SQTimestampFormFieldState extends SQFormFieldState<SQTimestampField> {
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (context) {
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
  Widget fieldBuilder(ScreenState screenState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.value.toString()),
        SQButton(
          'Select Date',
          onPressed: () async {
            final ret =
                await Navigator.of(screenState.context).push(_datePickerRoute(
              screenState.context,
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
