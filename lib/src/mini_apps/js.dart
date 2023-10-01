import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

export 'dart:convert' show jsonDecode, jsonEncode;
export 'dart:js' show JsArray, JsObject;

final webAppJsObject = (context['Telegram'] as JsObject)['WebApp'] as JsObject;

Future<T> jsCallbackToFuture<T>(
    JsObject js, String methodName, List<dynamic> args) {
  final completer = Completer<T>();
  final callback = JsFunction.withThis((_, dynamic arg1, dynamic arg2) {
    if (arg2 == null) return completer.complete(arg1 as T);
    return completer.complete(arg2 as T);
  });
  args.add(callback);
  js.callMethod(methodName, args);
  return completer.future;
}
