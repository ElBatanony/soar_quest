import 'js.dart';

enum PopupButtonType { ok, close, cancel, destructive }

class ScanQrPopupParams {
  ScanQrPopupParams(this.text)
      : assert(text == null || text.length < 64,
            'Max 64 characters in Scan QR text');

  final String? text;

  JsObject jsify() => JsObject.jsify({'text': text});
}

class PopupButton {
  PopupButton({this.id, this.type, this.text, this.onPressed})
      : assert(id == null || id.length < 64,
            'Max 64 characters in popup button id'),
        assert(text == null || text.length < 64,
            'Max 64 characters in popup button text'),
        assert(
            (type != PopupButtonType.destructive && type != null) ||
                text != null,
            '''Popup button text is required if default or destructive button type'''),
        assert(onPressed == null || id != null, 'onPressed requires an ID');

  final String? id;
  final PopupButtonType? type;
  final String? text;

  final void Function()? onPressed;
}
