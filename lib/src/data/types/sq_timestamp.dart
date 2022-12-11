import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class SQTimestamp extends Timestamp {
  SQTimestamp(super.seconds, super.nanoseconds);

  factory SQTimestamp.fromDate(DateTime date) {
    final timestamp = Timestamp.fromDate(date);
    return SQTimestamp(timestamp.seconds, timestamp.nanoseconds);
  }

  factory SQTimestamp.fromTimestamp(Timestamp timestamp) =>
      SQTimestamp(timestamp.seconds, timestamp.nanoseconds);

  factory SQTimestamp.now() => SQTimestamp.fromDate(DateTime.now());

  @override
  String toString() => toDate().toString().substring(0, 10);

  static SQTimestamp? parse(dynamic source) {
    if (source == null) return null;
    if (source is SQTimestamp) return source;
    if (source is Timestamp) return SQTimestamp.fromTimestamp(source);
    if (source is Map<String, dynamic> && source['_seconds'] is int)
      return SQTimestamp(source['_seconds'] as int, 0);
    return null;
  }

  Map<String, dynamic> toJson() => {'_seconds': seconds};
}
