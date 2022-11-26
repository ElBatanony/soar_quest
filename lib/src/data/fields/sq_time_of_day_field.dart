import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'types/sq_time_of_day.dart';

export 'types/sq_time_of_day.dart';

class SQTimeOfDayField extends SQField<SQTimeOfDay> {
  SQTimeOfDayField(super.name, {SQTimeOfDay? value, super.editable})
      : super(value: value ?? SQTimeOfDay.fromTimeOfDay(TimeOfDay.now()));

  @override
  SQTimeOfDay? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    return SQTimeOfDay.parse(source);
  }

  @override
  SQTimeOfDayField copy() =>
      SQTimeOfDayField(name, value: value, editable: editable);

  @override
  serialize() {
    if (value == null) return null;
    return {
      'hour': value?.hour,
      'minute': value?.minute,
    };
  }

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQTimeOfDayFormField(this, doc, onChanged: onChanged);
}

class _SQTimeOfDayFormField extends SQFormField<SQTimeOfDayField> {
  const _SQTimeOfDayFormField(super.field, super.doc,
      {required super.onChanged});

  void _selectTimeOfDay(
      TimeOfDay? newSelectedTimeOfDay, SQFormFieldState formFieldState) {
    if (newSelectedTimeOfDay != null) {
      field.value = SQTimeOfDay.fromTimeOfDay(newSelectedTimeOfDay);
      formFieldState.onChanged();
    }
  }

  TimeOfDay toTimeOfDay(SQTimeOfDay sqTimeOfDay) =>
      TimeOfDay(hour: sqTimeOfDay.hour, minute: sqTimeOfDay.minute);

  @override
  Widget fieldBuilder(formFieldState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.value.toString()),
          SQButton(
            'Select Time',
            onPressed: () async {
              final newTimeOfDay = await showTimePicker(
                context: formFieldState.context,
                initialTime: field.value != null
                    ? toTimeOfDay(field.value!)
                    : TimeOfDay.now(),
              );
              if (newTimeOfDay != null) {
                _selectTimeOfDay(newTimeOfDay, formFieldState);
              }
            },
          )
        ],
      );
}
