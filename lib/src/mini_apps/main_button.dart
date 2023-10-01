import 'color.dart';
import 'js.dart';

class MainButton {
  MainButton(this.js) {
    js.callMethod('onClick', [onClickCallback]);
  }

  JsObject js;

  String get text => js['text'] as String;
  Color get color => MiniAppColor(js['color'] as String?);
  Color get textColor => MiniAppColor(js['textColor'] as String?);
  bool get isVisible => js['isVisible'] as bool;
  bool get isActive => js['isActive'] as bool;
  bool get isProgressVisible => js['isProgressVisible'] as bool;

  void setText(String text) => setParams(text: text);

  void Function()? callback;
  void onClickCallback() => callback?.call();

  void show() => js.callMethod('show');
  void hide() => js.callMethod('hide');

  void enable() => js.callMethod('enable');
  void disable() => js.callMethod('disable');

  void showProgress({bool leaveActive = false}) =>
      js.callMethod('showProgress', [leaveActive]);

  void hideProgress() => js.callMethod('hideProgress');

  void setParams({
    String? text,
    Color? color,
    Color? textColor,
    bool? isActive,
    bool? isVisible,
  }) {
    js.callMethod('setParams', [
      JsObject.jsify({
        if (text != null) 'text': text,
        if (color != null) 'color': color.toHex(),
        if (textColor != null) 'text_color': textColor.toHex(),
        if (isActive != null) 'is_active': isActive,
        if (isVisible != null) 'is_visible': isVisible,
      })
    ]);
  }
}
