import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../data/types/sq_time_of_day.dart';
import '../ui/button.dart';

export '../data/types/sq_time_of_day.dart';

class SQTimeOfDayField extends SQField<SQTimeOfDay> {
  SQTimeOfDayField(super.name) {
    defaultValue = SQTimeOfDay.fromTimeOfDay(TimeOfDay.now());
  }

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
  formField(docScreen) => _SQTimeOfDayFormField(this, docScreen);
}

class _SQTimeOfDayFormField extends SQFormField<SQTimeOfDay, SQTimeOfDayField> {
  const _SQTimeOfDayFormField(super.field, super.docScreen);

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
