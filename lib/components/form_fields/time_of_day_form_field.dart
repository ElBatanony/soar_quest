import 'package:flutter/material.dart';

import '../doc_form_field.dart';
import '../buttons/sq_button.dart';
import '../../data/fields/sq_time_of_day_field.dart';
import '../../data/types/sq_time_of_day.dart';

class SQTimeOfDayFormField extends DocFormField<SQTimeOfDayField> {
  const SQTimeOfDayFormField(super.field,
      {super.onChanged, super.doc, super.key});

  @override
  createState() => _SQTimeOfDayFormFieldState();
}

class _SQTimeOfDayFormFieldState extends DocFormFieldState<SQTimeOfDayField> {
  void _selectTimeOfDay(TimeOfDay? newSelectedTimeOfDay) {
    if (newSelectedTimeOfDay != null) {
      field.value = SQTimeOfDay.fromTimeOfDay(newSelectedTimeOfDay);
      onChanged();
    }
  }

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
              initialTime: field.value?.toTimeOfDay() ?? TimeOfDay.now(),
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
