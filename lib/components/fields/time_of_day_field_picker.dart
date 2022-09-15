import 'package:flutter/material.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/fields/sq_time_of_day_field.dart';
import 'package:soar_quest/data/types/sq_time_of_day.dart';

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
