import 'package:flutter/material.dart';

class SQTimeOfDay extends TimeOfDay {
  const SQTimeOfDay({required super.hour, required super.minute});

  SQTimeOfDay.fromTimeOfDay(TimeOfDay timeOfDay)
      : this(hour: timeOfDay.hour, minute: timeOfDay.minute);

  @override
  String toString() {
    String pad(int x) => x.toString().padLeft(2, '0');
    return "${pad(hour)}:${pad(minute)}";
  }

  static SQTimeOfDay? parse(Map<String, dynamic> source) {
    if (source["hour"] != null && source["minute"] != null)
      return SQTimeOfDay(hour: source["hour"], minute: source["minute"]);

    return null;
  }
}
