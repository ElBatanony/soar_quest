import 'package:flutter/material.dart';

import '../../screens/collection_screens/video_screen.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';
import 'sq_text_field.dart';

class SQVideoLinkField extends SQStringField {
  SQVideoLinkField(super.name, {String? url, super.editable})
      : super(defaultValue: url ?? '');

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  formField(docScreenState) => _SQVideoLinkFormField(this, docScreenState);
}

class _SQVideoLinkFormField extends SQFormField<SQVideoLinkField> {
  const _SQVideoLinkFormField(super.field, super.docScreenState);

  @override
  Widget readOnlyBuilder(context) => VideoDocDisplay(doc, videoField: field);

  @override
  Widget fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
