import '../fields.dart';
import '../types.dart';

abstract class SQDocField<T> {
  String name = "";
  T? value;
  Type get type => T;
  final bool readOnly;

  SQDocField(this.name, {this.value, this.readOnly = false});

  SQDocField copy();

  dynamic collectField() => value;

  T? parse(dynamic source);

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }
}

class SQStringField extends SQDocField<String> {
  SQStringField(String name, {String value = "", super.readOnly})
      : super(name, value: value);

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name, value: value, readOnly: readOnly);

  @override
  String get value => super.value ?? "";
}

class SQBoolField extends SQDocField<bool> {
  SQBoolField(super.name, {super.value, super.readOnly});

  @override
  bool? parse(source) {
    if (source is bool) return source;
    return null;
  }

  @override
  SQBoolField copy() => SQBoolField(name, value: value, readOnly: readOnly);

  @override
  bool get value => super.value ?? false;
}

class SQIntField extends SQDocField<int> {
  SQIntField(super.name, {super.value, super.readOnly});

  @override
  int? parse(source) {
    if (source is int) value = source;
    return null;
  }

  @override
  SQIntField copy() => SQIntField(name, value: value, readOnly: readOnly);
}

class VideoLinkField extends SQDocField<String> {
  VideoLinkField(String name, {String? url, super.readOnly})
      : super(name, value: url ?? "");

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  VideoLinkField copy() => VideoLinkField(name, url: value, readOnly: readOnly);
}

// TODO: move fields to different files