import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class SQQRCodeDisplay extends StatelessWidget {
  const SQQRCodeDisplay({
    required this.string,
    required this.size,
    super.key,
  });

  final String string;
  final double size;

  @override
  Widget build(BuildContext context) => BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: string,
        width: size,
        height: size,
      );
}
