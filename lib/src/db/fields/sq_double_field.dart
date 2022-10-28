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
  formField({Function? onChanged, required SQDoc doc}) {
    return _SQDoubleFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQDoubleFormField extends SQFormField<SQDoubleField> {
  const _SQDoubleFormField(super.field, {super.onChanged, required super.doc});

  @override
  createState() => _SQDoubleFormFieldState();
}

class _SQDoubleFormFieldState extends SQFormFieldState<SQDoubleField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => double.tryParse(text));
  }
}
