import 'package:flutter/material.dart';

import '../../mini_apps.dart';
import '../data/sq_field.dart';
import '../fields/string_field.dart';
import '../ui/button.dart';
import '../ui/qr_code_display.dart';
import '../ui/text_field.dart';

class MiniAppQRCodeField extends SQStringField {
  MiniAppQRCodeField(super.name, {this.showStringField = true});

  final bool showStringField;

  @override
  formField(docScreen) => _MiniAppQRCodeFormField(this, docScreen);
}

class _MiniAppQRCodeFormField extends SQFormField<String, MiniAppQRCodeField> {
  const _MiniAppQRCodeFormField(super.field, super.docScreen);

  Future<void> displayQRCode(BuildContext context, String qrCodeString) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(field.name),
          content: SQQRCodeDisplay(string: qrCodeString, size: 200),
          actions: [_closeDialogButton(context)],
        ),
      );

  Future<void> scanQRCode(BuildContext context) async {
    final qrCode =
        await MiniApp.showScanQrPopup(ScanQrPopupParams('Scan ${field.name}'));
    MiniApp.closeScanQrPopup();
    if (qrCode != null) setDocValue(qrCode);
  }

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
