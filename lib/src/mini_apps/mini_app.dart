import 'back_button.dart';
import 'cloud_storage.dart';
import 'init_data.dart';
import 'js.dart';
import 'main_button.dart';
import 'popups.dart';
import 'theme_params.dart';

class MiniApp {
  MiniApp.init() {
    js = webAppJsObject;
    version = js['version'] as String;
    platform = js['platform'] as String;
    initData = WebAppInitData(
        js['initDataUnsafe'] as JsObject, js['initData'] as String);
    backButton = MiniAppBackButton(js['BackButton'] as JsObject);
    mainButton = MainButton(js['MainButton'] as JsObject);
    cloudStorage = CloudStorage(js['CloudStorage'] as JsObject);
    themeParams =
        ThemeParams(js['themeParams'] as JsObject, js['colorScheme'] as String);
  }

  static late final JsObject js;

  static late final WebAppInitData initData;
  static late final String version;
  static late final String platform;
  static Brightness get colorScheme => themeParams.colorScheme;
  static late final ThemeParams themeParams;

  static bool get isExpanded => js['isExpanded'] as bool;

  static double get viewportHeight => js['viewportHeight'] as double;
  static double get viewportStableHeight =>
      js['viewportStableHeight'] as double;

  static Color get headerColor => MiniAppColor(js['headerColor']);
  static Color get backgroundColor => MiniAppColor(js['backgroundColor']);

  static bool get isClosingConfirmationEnabled =>
      js['isClosingConfirmationEnabled'] as bool;

  static late final MiniAppBackButton backButton;
  static late final MainButton mainButton;
  static late final CloudStorage cloudStorage;

  static bool isVersionAtLeast(String version) =>
      js.callMethod('isVersionAtLeast', [version]) as bool;

  static void setHeaderColor(Color color) =>
      js.callMethod('setHeaderColor', [color.toHex()]);

  static void setBackgroundColor(Color color) =>
      js.callMethod('setBackgroundColor', [color.toHex()]);

  static void enableClosingConfirmation() =>
      js.callMethod('enableClosingConfirmation');

  static void disableClosingConfirmation() =>
      js.callMethod('disableClosingConfirmation');

  static void openLink(String url, {bool tryInstantView = false}) =>
      js.callMethod('openLink', [
        url,
        JsObject.jsify({'try_instant_view': tryInstantView}),
      ]);

  static void openTelegramLink(String url) =>
      js.callMethod('openTelegramLink', [url]);

  static Future<String> showPopup(PopupParams params,
      [void Function()? callback]) async {
    final buttonId =
        await jsCallbackToFuture<String>(js, 'showPopup', [params.jsify()]);
    if (buttonId.isNotEmpty)
      params.buttons
          ?.firstWhere((button) => button.id == buttonId)
          .onPressed
          ?.call();
    return buttonId;
  }

  static Future<void> showAlert(String message) => jsCallbackToFuture(
      js, 'showAlert', [if (message.isEmpty) 'Empty string' else message]);

  static Future<bool> showConfirm(String message) => jsCallbackToFuture<bool>(
      js, 'showConfirm', [if (message.isEmpty) 'Empty string' else message]);

  static Future<String?> showScanQrPopup(ScanQrPopupParams params) =>
      jsCallbackToFuture<String>(
          js, 'showScanQrPopup', [if (params.text != null) params.jsify()]);

  static void closeScanQrPopup() => js.callMethod('closeScanQrPopup');

  static void requestWriteAccess() => js.callMethod('requestWriteAccess');
  static void requestContact() => js.callMethod('requestContact');

  static void ready() => js.callMethod('ready');
  static void expand() => js.callMethod('expand');
  static void close() => js.callMethod('close');
}
