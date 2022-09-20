import 'package:flutter/material.dart';

import '../doc_form_field.dart';
import '../buttons/sq_button.dart';
import '../../data/fields/sq_time_of_day_field.dart';
import '../../data/types/sq_time_of_day.dart';

class SQTimeOfDayFormField extends DocFormField {
  const SQTimeOfDayFormField(super.field,
      {required super.onChanged, super.doc, super.key});

  @override
  State<SQTimeOfDayFormField> createState() => _SQTimeOfDayFormFieldState();
}

class _SQTimeOfDayFormFieldState
    extends DocFormFieldState<SQTimeOfDayFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.field.name),
        Text(widget.field.value.toString()),
        TimeOfDayFieldPicker(
            timeOfDayField: widget.field as SQTimeOfDayField,
            updateCallback: onChanged),
      ],
    );
  }
}

class TimeOfDayFieldPicker extends StatefulWidget {
  const TimeOfDayFieldPicker(
      {required this.timeOfDayField, required this.updateCallback, super.key});

  final SQTimeOfDayField timeOfDayField;
  final Function updateCallback;

  @override
  State<TimeOfDayFieldPicker> createState() => _TimeOfDayFieldPickerState();
}

class _TimeOfDayFieldPickerState extends State<TimeOfDayFieldPicker> {
  void _selectTimeOfDay(TimeOfDay? newSelectedTimeOfDay) {
    if (newSelectedTimeOfDay != null) {
      widget.timeOfDayField.value =
          SQTimeOfDay.fromTimeOfDay(newSelectedTimeOfDay);
      widget.updateCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SQButton(
      'Select Time',
      onPressed: () async {
        TimeOfDay? newTimeOfDay = await showTimePicker(
          context: context,
          initialTime:
              widget.timeOfDayField.value?.toTimeOfDay() ?? TimeOfDay.now(),
        );
        if (newTimeOfDay != null) {
          _selectTimeOfDay(newTimeOfDay);
        }
      },
    );
  }
}
