import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQStringField extends SQField<String> {
  SQStringField(super.name,
      {super.value, super.editable, super.require, super.show});

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name,
      value: value, editable: editable, require: require, show: show);

  @override
  SQFormField formField({Function? onChanged, required SQDoc doc}) {
    return _SQStringFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQStringFormField extends SQFormField<SQStringField> {
  const _SQStringFormField(super.field,
      {required super.onChanged, required super.doc});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends SQFormFieldState<SQStringField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => text);
  }
}
