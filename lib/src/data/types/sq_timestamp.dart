// Parts of implementation borrowed from Firebase Cloud Firestore's Timestamp
// https://pub.dev/packages/cloud_firestore

import 'package:flutter/material.dart';

const int _kThousand = 1000;
const int _kMillion = 1000000;

@immutable
class SQTimestamp implements Comparable<SQTimestamp> {
  const SQTimestamp(this.seconds, this.nanoseconds);

  factory SQTimestamp.fromMicrosecondsSinceEpoch(int microseconds) {
    final seconds = microseconds ~/ _kMillion;
    final nanoseconds = (microseconds - seconds * _kMillion) * _kThousand;
    return SQTimestamp(seconds, nanoseconds);
  }
  factory SQTimestamp.fromDate(DateTime date) =>
      SQTimestamp.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);

  factory SQTimestamp.now() => SQTimestamp.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch,
      );

  final int seconds;
  final int nanoseconds;

  int get microsecondsSinceEpoch =>
      seconds * _kMillion + nanoseconds ~/ _kThousand;

  DateTime toDate() =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  @override
  String toString() => toDate().toString().substring(0, 10);

  static SQTimestamp? parse(dynamic source) {
    if (source is SQTimestamp) return source;
    if (source is Map<String, dynamic> && source['_seconds'] is int)
      return SQTimestamp(source['_seconds'] as int, 0);
    return null;
  }

  Map<String, dynamic> toJson() => {'_seconds': seconds};

  @override
  int get hashCode => Object.hash(seconds, nanoseconds);

  @override
  bool operator ==(Object other) =>
      other is SQTimestamp &&
      other.seconds == seconds &&
      other.nanoseconds == nanoseconds;

  @override
  int compareTo(SQTimestamp other) {
    if (seconds == other.seconds)
      return nanoseconds.compareTo(other.nanoseconds);

    return seconds.compareTo(other.seconds);
  }
}
