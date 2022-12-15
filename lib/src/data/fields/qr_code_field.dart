import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../ui/sq_button.dart';
import '../../ui/sq_qr_code_display.dart';
import '../../ui/sq_text_field.dart';
import '../sq_field.dart';
import 'string_field.dart';

class SQQRCodeField extends SQStringField {
  SQQRCodeField(super.name);

  @override
  formField(docScreenState) => _SQQRCodeFormField(this, docScreenState);
}

class _SQQRCodeFormField extends SQFormField<String, SQQRCodeField> {
  const _SQQRCodeFormField(super.field, super.docScreenState);

  Future<void> displayQRCode(BuildContext context, String qrCodeString) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(field.name),
          content: SQQRCodeDisplay(string: qrCodeString, size: 200),
          actions: [_closeDialogButton(context)],
        ),
      );

  Future<void> scanQRCode(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Scan ${field.name}'),
          content: SizedBox(
            height: 350,
            child: MobileScanner(
              controller:
                  MobileScannerController(formats: [BarcodeFormat.qrCode]),
              onDetect: (capture) {
                final newString = capture.barcodes.first.rawValue;
                if (newString != null) setDocValue(newString);
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [_closeDialogButton(context)],
        ),
      );

  TextButton _closeDialogButton(BuildContext context) => TextButton(
        style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge),
        child: const Text('Close'),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget fieldLabel(BuildContext context) {
    final stringValue = getDocValue();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        super.fieldLabel(context),
        if (stringValue != null && !isInFormScreen)
          SQButton.icon(Icons.qr_code_2,
              text: 'Display',
              onPressed: () async => displayQRCode(context, stringValue)),
        if (isInFormScreen)
          SQButton.icon(Icons.qr_code_2,
              text: 'Scan', onPressed: () async => scanQRCode(context))
      ],
    );
  }

  @override
  Widget fieldBuilder(BuildContext context) =>
      SQTextField(this, textParse: (text) => text, maxLines: field.maxLines);
}
