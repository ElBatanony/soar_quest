import 'package:flutter/material.dart';

import '../../screens/collection_screens/video_screen.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';
import 'sq_text_field.dart';

class SQVideoLinkField extends SQStringField {
  SQVideoLinkField(super.name, {String? url, super.editable})
      : super(value: url ?? '');

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQVideoLinkField copy() =>
      SQVideoLinkField(name, url: value, editable: editable);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQVideoLinkFormField(this, doc, onChanged: onChanged);
}

class _SQVideoLinkFormField extends SQFormField<SQVideoLinkField> {
  const _SQVideoLinkFormField(super.field, super.doc,
      {required super.onChanged});

  @override
  Widget readOnlyBuilder(ScreenState screenState) =>
      VideoDocDisplay(doc, videoField: field);

  @override
  createState() => _SQVideoLinkFormFieldState();
}

class _SQVideoLinkFormFieldState extends SQFormFieldState<SQVideoLinkField> {
  @override
  Widget fieldBuilder(ScreenState screenState) =>
      SQTextField(formField, textParse: (text) => text);
}
