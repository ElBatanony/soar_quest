import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
export 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class SQTimestamp extends Timestamp {
  SQTimestamp(super.seconds, super.nanoseconds);

  factory SQTimestamp.fromDate(DateTime date) {
    Timestamp timestamp = Timestamp.fromDate(date);
    return SQTimestamp(timestamp.seconds, timestamp.nanoseconds);
  }

  factory SQTimestamp.fromTimestamp(Timestamp timestamp) {
    return SQTimestamp(timestamp.seconds, timestamp.nanoseconds);
  }

  @override
  String toString() {
    return toDate().toString().substring(0, 10);
  }

  static SQTimestamp? parse(dynamic source) {
    if (source is Timestamp)
      return SQTimestamp.fromTimestamp(source);
    else if (source["_seconds"] is int)
      return SQTimestamp(source["_seconds"] as int, 0);
    return null;
  }
}
