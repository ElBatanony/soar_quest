import 'js.dart';

class ScanQrPopupParams {
  ScanQrPopupParams(this.text)
      : assert(text == null || text.length < 64,
            'Max 64 characters in Scan QR text');

  final String? text;

  JsObject jsify() => JsObject.jsify({'text': text});
}
