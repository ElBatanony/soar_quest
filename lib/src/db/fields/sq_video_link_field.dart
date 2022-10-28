import 'package:flutter/material.dart';

import '../../screens/collection_screens/video_screen.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';
import 'sq_text_field.dart';

class SQVideoLinkField extends SQStringField {
  SQVideoLinkField(String name, {String? url, super.editable})
      : super(name, value: url ?? "");

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQVideoLinkField copy() =>
      SQVideoLinkField(name, url: value, editable: editable);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQVideoLinkFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQVideoLinkFormField extends SQFormField<SQVideoLinkField> {
  const _SQVideoLinkFormField(super.field,
      {required super.onChanged, required super.doc});

  @override
  createState() => _SQVideoLinkFormFieldState();
}

class _SQVideoLinkFormFieldState extends SQFormFieldState<SQVideoLinkField> {
  @override
  Widget readOnlyBuilder(BuildContext context) {
    if (formField.doc == null) return super.readOnlyBuilder(context);
    return VideoDocDisplay(formField.doc!, videoField: field);
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => text);
  }
}
