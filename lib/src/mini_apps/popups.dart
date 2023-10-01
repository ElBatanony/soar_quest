import 'js.dart';

enum PopupButtonType { ok, close, cancel, destructive }

class PopupParams {
  PopupParams({
    required this.message,
    this.title,
    this.buttons,
  })  : assert(title == null || title.length < 64,
            'Max 64 characters in popup title'),
        assert(message.isNotEmpty && message.length <= 256,
            'Popup messages must be 1-256 characters'),
        assert(buttons == null || (buttons.isNotEmpty && buttons.length <= 3),
            'Popup should have 1-3 buttons');

  final String? title;
  final String message;
  final List<PopupButton>? buttons;

  JsObject jsify() => JsObject.jsify({
        'message': message,
        'title': title,
        if (buttons != null)
          'buttons': [
            for (final button in buttons!)
              JsObject.jsify({
                if (button.id != null) 'id': button.id,
                'type': button.type?.name ?? 'default',
                if (button.text != null) 'text': button.text
              })
          ],
      });
}

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
