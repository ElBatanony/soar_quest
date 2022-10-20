import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQStringField extends SQField<String> {
  SQStringField(super.name, {super.value, super.editable, super.require});

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() =>
      SQStringField(name, value: value, editable: editable, require: require);

  @override
  SQFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQStringFormField(this, onChanged: onChanged);
  }
}

class _SQStringFormField extends SQFormField<SQStringField> {
  const _SQStringFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends SQFormFieldState<SQStringField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => text);
  }
}
