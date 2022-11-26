import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';
import 'sq_text_field.dart';

class SQLinkField extends SQStringField {
  SQLinkField(super.name, {super.value, super.editable});

  @override
  SQLinkField copy() => SQLinkField(name, value: value, editable: editable);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQLinkFormField(this, doc, onChanged: onChanged);
}

class _SQLinkFormField extends SQFormField<SQLinkField> {
  const _SQLinkFormField(super.field, super.doc, {required super.onChanged});

  @override
  Widget readOnlyBuilder(formFieldState) {
    final url = field.value;
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
  Widget fieldBuilder(formFieldState) =>
      SQTextField(this, textParse: (text) => text);

  @override
  createState() => _SQLinkFormFieldState();
}

class _SQLinkFormFieldState extends SQFormFieldState<SQLinkField> {}
