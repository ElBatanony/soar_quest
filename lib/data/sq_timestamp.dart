import 'package:cloud_firestore/cloud_firestore.dart';

class SQTimestamp extends Timestamp {
  SQTimestamp(super.seconds, super.nanoseconds);

  factory SQTimestamp.fromDate(DateTime date) {
    Timestamp timestamp = Timestamp.fromDate(date);
    return SQTimestamp(timestamp.seconds, timestamp.nanoseconds);
  }

  factory SQTimestamp.fromTimestamp(dynamic timestamp) {
    return SQTimestamp(timestamp.seconds, timestamp.nanoseconds);
  }

  @override
  String toString() {
    return toDate().toString().substring(0, 10);
  }
}
