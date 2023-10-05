import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../ui/text_field.dart';
import 'string_field.dart';

class SQImageLinkField extends SQStringField {
  SQImageLinkField(super.name);

  @override
  formField(docScreen) => _SQImageLinkFormField(this, docScreen);
}

class _SQImageLinkFormField extends SQFormField<String, SQImageLinkField> {
  const _SQImageLinkFormField(super.field, super.docScreen);

  @override
  Widget readOnlyBuilder(context) {
    final imageUrl = getDocValue();
    if (imageUrl == null) return const Text('No Image');
    return Image.network(imageUrl);
  }

  @override
  fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
