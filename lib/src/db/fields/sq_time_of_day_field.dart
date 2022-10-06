import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'types/sq_time_of_day.dart';
import '../../ui/sq_button.dart';

export 'types/sq_time_of_day.dart';

class SQTimeOfDayField extends SQField<SQTimeOfDay> {
  SQTimeOfDayField(String name, {SQTimeOfDay? value, super.readOnly})
      : super(name, value: value ?? SQTimeOfDay.fromTimeOfDay(TimeOfDay.now()));

  @override
  SQTimeOfDay? parse(source) {
    return SQTimeOfDay.parse(source);
  }

  @override
  SQTimeOfDayField copy() =>
      SQTimeOfDayField(name, value: value, readOnly: readOnly);

  @override
  serialize() {
    if (value == null) return null;
    return {
      "hour": value?.hour,
      "minute": value?.minute,
    };
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQTimeOfDayFormField(this, onChanged: onChanged);
  }
}

class _SQTimeOfDayFormField extends SQFormField<SQTimeOfDayField> {
  const _SQTimeOfDayFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQTimeOfDayFormFieldState();
}

class _SQTimeOfDayFormFieldState extends SQFormFieldState<SQTimeOfDayField> {
  void _selectTimeOfDay(TimeOfDay? newSelectedTimeOfDay) {
    if (newSelectedTimeOfDay != null) {
      field.value = SQTimeOfDay.fromTimeOfDay(newSelectedTimeOfDay);
      onChanged();
    }
  }

  TimeOfDay toTimeOfDay(SQTimeOfDay sqTimeOfDay) =>
      TimeOfDay(hour: sqTimeOfDay.hour, minute: sqTimeOfDay.minute);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        Text(field.value.toString()),
        SQButton(
          'Select Time',
          onPressed: () async {
            TimeOfDay? newTimeOfDay = await showTimePicker(
              context: context,
              initialTime: field.value != null
                  ? toTimeOfDay(field.value!)
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
}
