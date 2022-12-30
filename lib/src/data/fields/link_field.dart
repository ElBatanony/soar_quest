import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui/button.dart';
import '../../ui/text_field.dart';
import '../sq_field.dart';
import 'string_field.dart';

class SQLinkField extends SQStringField {
  SQLinkField(super.name);

  @override
  formField(docScreen) => _SQLinkFormField(this, docScreen);
}

class _SQLinkFormField extends SQFormField<String, SQLinkField> {
  const _SQLinkFormField(super.field, super.docScreen);

  @override
  readOnlyBuilder(context) {
    final url = getDocValue();
    if (url != null)
      return SQButton('Open Link', onPressed: () async {
        if (!await launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      });
    return const Text('No Link');
  }

  @override
  fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
