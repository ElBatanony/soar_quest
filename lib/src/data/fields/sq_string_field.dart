import 'package:flutter/material.dart';

import '../sq_doc.dart';
import 'sq_text_field.dart';

class SQStringField extends SQField<String> {
  final int maxLines;

  SQStringField(super.name,
      {super.value,
      super.editable,
      super.require,
      super.show,
      this.maxLines = 1});

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name,
      value: value,
      editable: editable,
      require: require,
      show: show,
      maxLines: maxLines);

  @override
  SQFormField formField(SQDoc doc, {Function? onChanged}) {
    return _SQStringFormField(this, doc, onChanged: onChanged);
  }
}

class _SQStringFormField extends SQFormField<SQStringField> {
  const _SQStringFormField(super.field, super.doc, {required super.onChanged});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends SQFormFieldState<SQStringField> {
  @override
  Widget fieldBuilder(ScreenState screenState) {
    return SQTextField(
      formField,
      textParse: (text) => text,
      maxLines: field.maxLines,
    );
  }
}
