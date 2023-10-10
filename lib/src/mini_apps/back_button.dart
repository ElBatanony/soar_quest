import 'js.dart';

class MiniAppBackButton {
  MiniAppBackButton(this.js) {
    js.callMethod('onClick', [JsFunction.withThis(onClickCallback)]);
  }

  JsObject js;

  bool get isVisible => js['isVisible'] as bool;

  void onClickCallback(_) => callback?.call();

  void Function()? callback;

  void show() => js.callMethod('show');
  void hide() => js.callMethod('hide');
}
