import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../ui/button.dart';
import '../../ui/qr_code_display.dart';
import '../../ui/text_field.dart';
import '../sq_field.dart';
import 'string_field.dart';

class SQQRCodeField extends SQStringField {
  SQQRCodeField(super.name, {this.showStringField = true});

  final bool showStringField;

  @override
  formField(docScreen) => _SQQRCodeFormField(this, docScreen);
}

class _SQQRCodeFormField extends SQFormField<String, SQQRCodeField> {
  const _SQQRCodeFormField(super.field, super.docScreen);

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
                Navigator.of(context).pop();
                if (newString != null) setDocValue(newString);
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
  Widget fieldBuilder(BuildContext context) => field.showStringField
      ? SQTextField(this, textParse: (text) => text, maxLines: field.maxLines)
      : Container();
}
