import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

typedef FieldBuilder = Widget Function(SQDoc doc);

class SQVirtualField extends SQField<String> {
  FieldBuilder fieldBuilder;

  SQVirtualField(super.name, {required this.fieldBuilder, super.value})
      : super(readOnly: true);

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQVirtualField copy() =>
      SQVirtualField(name, fieldBuilder: fieldBuilder, value: value);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    throw UnimplementedError();
  }

  @override
  readOnlyField({SQDoc? doc}) {
    return _SQVirtualFieldFormField(this, doc: doc);
  }
}

class _SQVirtualFieldFormField extends SQFormField<SQVirtualField> {
  const _SQVirtualFieldFormField(super.field, {required super.doc});

  @override
  createState() => _SQVirtualFieldState();
}

class _SQVirtualFieldState extends SQFormFieldState<SQVirtualField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return field.fieldBuilder(doc!);
  }
}
