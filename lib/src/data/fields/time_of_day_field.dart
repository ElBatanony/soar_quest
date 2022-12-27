import 'package:flutter/material.dart';

import '../../ui/button.dart';
import '../sq_doc.dart';
import '../types/sq_time_of_day.dart';

export '../types/sq_time_of_day.dart';

class SQTimeOfDayField extends SQField<SQTimeOfDay> {
  SQTimeOfDayField(super.name, {SQTimeOfDay? defaultValue, super.editable})
      : super(
            defaultValue:
                defaultValue ?? SQTimeOfDay.fromTimeOfDay(TimeOfDay.now()));

  @override
  SQTimeOfDay? parse(source) {
    if (source is Map<String, dynamic> && source.containsKey('hour'))
      return SQTimeOfDay.parse(source);
    return super.parse(source);
  }

  @override
  serialize(value) {
    if (value == null) return null;
    return {
      'hour': value.hour,
      'minute': value.minute,
    };
  }

  @override
  formField(docScreenState) => _SQTimeOfDayFormField(this, docScreenState);
}

class _SQTimeOfDayFormField extends SQFormField<SQTimeOfDay, SQTimeOfDayField> {
  const _SQTimeOfDayFormField(super.field, super.docScreenState);

  void _selectTimeOfDay(TimeOfDay? newSelectedTimeOfDay) {
    if (newSelectedTimeOfDay != null) {
      setDocValue(SQTimeOfDay.fromTimeOfDay(newSelectedTimeOfDay));
    }
  }

  TimeOfDay toTimeOfDay(SQTimeOfDay sqTimeOfDay) =>
      TimeOfDay(hour: sqTimeOfDay.hour, minute: sqTimeOfDay.minute);

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getDocValue().toString()),
          SQButton(
            'Select Time',
            onPressed: () async {
              final newTimeOfDay = await showTimePicker(
                context: context,
                initialTime: getDocValue() != null
                    ? toTimeOfDay(getDocValue()!)
                    : TimeOfDay.now(),
              );
              if (newTimeOfDay != null) {
                _selectTimeOfDay(newTimeOfDay);
              }
            },
          )
        ],
      );
}