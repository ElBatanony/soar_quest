import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQDoubleField extends SQField<double> {
  SQDoubleField(super.name, {super.value, super.editable});

  @override
  double? parse(source) {
    if (source is double) return source;
    if (source is int) return source.toDouble();
    return null;
  }

  @override
  SQDoubleField copy() => SQDoubleField(name, value: value, editable: editable);

  @override
  formField(docScreenState) => _SQDoubleFormField(this, docScreenState);
}

class _SQDoubleFormField extends SQFormField<SQDoubleField> {
  const _SQDoubleFormField(super.field, super.docScreenState);

  @override
  Widget fieldBuilder(formFieldState) =>
      SQTextField(this, textParse: double.tryParse);
}
