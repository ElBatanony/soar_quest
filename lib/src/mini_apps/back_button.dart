import 'dart:js';

class MiniAppBackButton {
  MiniAppBackButton(this.js) {
    js.callMethod('onClick', [onClickCallback]);
  }

  JsObject js;

  bool get isVisible => js['isVisible'] as bool;

  void onClickCallback() => callback?.call();

  void Function()? callback;

  void show() => js.callMethod('show');
  void hide() => js.callMethod('hide');
}
