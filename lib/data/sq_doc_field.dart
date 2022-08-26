import 'package:cloud_firestore/cloud_firestore.dart';
import '../data.dart';

export 'sq_timestamp.dart' show SQTimestamp;
export 'doc_list_field.dart';
export 'sq_file_field.dart';

const List<Type> sQDocFieldTypes = [int, String, bool, SQTimestamp, List, Null];

class SQDocField<T> {
  String name = "";
  T? value;
  Type get type => T;

  SQDocField(this.name, {this.value});

  SQDocField<T> copy() {
    return SQDocField<T>(name, value: value);
  }

  dynamic collectField() => value;

  static SQDocField fromDynamic(dynamicValue, {String name = ""}) {
    switch (dynamicValue.runtimeType) {
      case String:
        return SQStringField(name, value: dynamicValue);
      case bool:
        return SQBoolField(name, value: dynamicValue);
      case Timestamp:
        return SQTimestampField(name,
            value: SQTimestamp.fromTimestamp(dynamicValue));
      case List:
        return SQDocListField(name, value: dynamicValue);
      default:
        throw UnimplementedError(
            "Dynamic SQDocField type of field not expexted");
    }
  }

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }
}

class SQStringField extends SQDocField<String> {
  SQStringField(String name, {String value = ""}) : super(name, value: value);
}

class SQBoolField extends SQDocField<bool> {
  SQBoolField(String name, {bool value = false}) : super(name, value: value);
}

class SQTimestampField extends SQDocField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value})
      : super(name, value: value ?? SQTimestamp(0, 0));
}

class VideoLinkField extends SQDocField<String> {
  VideoLinkField(String name, {String? url}) : super(name, value: url ?? "");
}
