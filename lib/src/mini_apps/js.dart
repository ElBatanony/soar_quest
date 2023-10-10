import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

export 'dart:convert' show jsonDecode, jsonEncode;
export 'dart:js' show JsArray, JsObject;

final webAppJsObject = (context['Telegram'] as JsObject)['WebApp'] as JsObject;

Future<T> jsCallbackToFuture<T>(
    JsObject js, String methodName, List<dynamic> args) {
  final completer = Completer<T>();
  js.callMethod(methodName, [
    ...args,
    JsFunction.withThis((_, dynamic ret1) {
      completer.complete(ret1 as T);
    })
  ]);
  return completer.future;
}
