import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui/sq_button.dart';
import '../../ui/sq_text_field.dart';
import '../sq_field.dart';
import 'sq_string_field.dart';

class SQLinkField extends SQStringField {
  SQLinkField(super.name, {super.defaultValue, super.editable});

  @override
  formField(docScreenState) => _SQLinkFormField(this, docScreenState);
}

class _SQLinkFormField extends SQFormField<String, SQLinkField> {
  const _SQLinkFormField(super.field, super.docScreenState);

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
