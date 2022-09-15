import 'package:flutter/material.dart';

import '../fields.dart';
import '../types.dart';

class SQTimeOfDayField extends SQDocField<SQTimeOfDay> {
  SQTimeOfDayField(String name, {SQTimeOfDay? value, super.readOnly})
      : super(name, value: value ?? SQTimeOfDay.fromTimeOfDay(TimeOfDay.now()));

  @override
  SQTimeOfDay parse(source) {
    return SQTimeOfDay.parse(source);
  }

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
