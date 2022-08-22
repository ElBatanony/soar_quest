import 'package:cloud_firestore/cloud_firestore.dart';
import '../data.dart';

export 'sq_timestamp.dart' show SQTimestamp;

const List<Type> sQDocFieldTypes = [int, String, bool, SQTimestamp, List, Null];

Map<Type, dynamic> defaultTypeValue = {
  int: 0,
  String: "",
  bool: false,
  SQTimestamp: SQTimestamp(0, 0),
  List: <SQDocField>[],
  SQDocReference: SQDocReference(collection: userCollection),
  Null: null,
};

class SQDocField<T> {
  String name = "";
  T value;
  Type get type => value.runtimeType;

  T get defaultValue => defaultTypeValue[type];

  SQDocField(this.name, {required this.value});

  SQDocField copy() {
    return SQDocField(name, value: value);
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

class SQDocListField extends SQDocField<List<SQDocField>> {
  SQDocListField(String name, {List<SQDocField> value = const <SQDocField>[]})
      : super(name, value: value);

  @override
  Type get type => List;

  @override
  SQDocField copy() {
    return SQDocListField(name, value: [...value]);
  }

  @override
  List<dynamic> collectField() {
    return value.map((listItemField) => listItemField.collectField()).toList();
  }
}

class SQDocReferenceField extends SQDocField<SQDocReference> {
  SQDocReferenceField(String name, {required SQDocReference value})
      : super(name, value: value);

  @override
  Type get type => SQDocReference;

  @override
  SQDocField copy() {
    return SQDocReferenceField(name, value: value);
  }

  @override
  Map<String, dynamic> collectField() {
    return {
      "docId": value.doc?.id ?? "",
      "collectionPath": value.collection.getPath()
    };
  }
}
