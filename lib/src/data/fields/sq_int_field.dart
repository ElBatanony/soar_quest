import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQIntField extends SQField<int> {
  SQIntField(super.name,
      {super.defaultValue, super.editable, super.require, super.show});

  @override
  int? parse(source) {
    if (source is int) return source;
    return null;
  }

  @override
  formField(docScreenState) => _SQIntFormField(this, docScreenState);

  int sumDocs(List<SQDoc> docs) =>
      docs.fold(0, (sum, doc) => sum + (doc.getValue<int>(name) ?? 0));
}

class _SQIntFormField extends SQFormField<int, SQIntField> {
  const _SQIntFormField(super.field, super.docScreenState);

  @override
  Widget fieldBuilder(context) => SQTextField(this, textParse: int.tryParse);
}
