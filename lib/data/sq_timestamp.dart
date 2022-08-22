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

  static SQTimestamp parse(dynamic source) {
    if (source.runtimeType == Timestamp)
      return SQTimestamp.fromTimestamp(source);
    else if (source["_seconds"] != null)
      return SQTimestamp(source["_seconds"], 0);
    else
      throw UnimplementedError("Timestamp variant not handled properly");
  }
}
