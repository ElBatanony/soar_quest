import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../../ui/sq_qr_code_display.dart';
import '../../ui/sq_text_field.dart';
import '../sq_field.dart';
import 'sq_string_field.dart';

class SQQRCodeField extends SQStringField {
  SQQRCodeField(super.name);

  @override
  formField(docScreenState) => _SQQRCodeFormField(this, docScreenState);
}

class _SQQRCodeFormField extends SQFormField<String, SQQRCodeField> {
  const _SQQRCodeFormField(super.field, super.docScreenState);

  Future<void> displayQRCode(BuildContext context, String qrCodeString) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(field.name),
          content: SQQRCodeDisplay(string: qrCodeString, size: 200),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

  @override
  Widget fieldLabel(BuildContext context) {
    final stringValue = getDocValue();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        super.fieldLabel(context),
        if (stringValue != null)
          SQButton.icon(Icons.qr_code_2,
              text: 'Display',
              onPressed: () async => displayQRCode(context, stringValue)),
      ],
    );
  }

  @override
  Widget fieldBuilder(BuildContext context) =>
      SQTextField(this, textParse: (text) => text, maxLines: field.maxLines);
}
