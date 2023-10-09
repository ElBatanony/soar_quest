import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../ui/text_field.dart';
import '../ui/video_display.dart';
import 'string_field.dart';

class SQVideoIDField extends SQStringField {
  SQVideoIDField(super.name);

  @override
  formField(docScreen) => _SQVideoLinkFormField(this, docScreen);
}

class _SQVideoLinkFormField extends SQFormField<String, SQVideoIDField> {
  const _SQVideoLinkFormField(super.field, super.docScreen);

  @override
  readOnlyBuilder(context) => getDocValue() == null
      ? const Text('No Video')
      : VideoDisplayWidget(doc, field);

  @override
  fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
