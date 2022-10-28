import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQIntField extends SQField<int> {
  SQIntField(super.name,
      {super.value, super.editable, super.require, super.show});

  @override
  int? parse(source) {
    if (source is int) return source;
    return null;
  }

  @override
  SQIntField copy() => SQIntField(name,
      value: value, editable: editable, require: require, show: show);

  @override
  formField({Function? onChanged, required SQDoc doc}) {
    return _SQIntFormField(this, onChanged: onChanged, doc: doc);
  }

  int sumDocs(List<SQDoc> docs) {
    return docs.fold(0, (sum, doc) => sum + (doc.value<int>(name) ?? 0));
  }
}

class _SQIntFormField extends SQFormField<SQIntField> {
  const _SQIntFormField(super.field,
      {required super.onChanged, required super.doc});

  @override
  createState() => _SQIntFormFieldState();
}

class _SQIntFormFieldState extends SQFormFieldState<SQIntField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => int.tryParse(text));
  }
}
