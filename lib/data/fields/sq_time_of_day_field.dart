import 'package:flutter/material.dart';

import '../../data.dart';
import '../types/sq_time_of_day.dart';

class SQTimeOfDayField extends SQDocField<SQTimeOfDay> {
  SQTimeOfDayField(String name, {SQTimeOfDay? value, super.readOnly})
      : super(name, value: value ?? SQTimeOfDay.fromTimeOfDay(TimeOfDay.now()));

  @override
  SQTimeOfDayField copy() =>
      SQTimeOfDayField(name, value: value, readOnly: readOnly);

  @override
  collectField() {
    if (value == null) return null;
    return {
      "hour": value?.hour,
      "minute": value?.minute,
    };
  }
}
