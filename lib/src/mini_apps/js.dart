import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

export 'dart:convert' show jsonDecode, jsonEncode;
export 'dart:js' show JsArray, JsFunction, JsObject;

final webAppJsObject = (context['Telegram'] as JsObject)['WebApp'] as JsObject;

Future<void> jsCallbackToFuture0(
    JsObject js, String methodName, List<dynamic> args) {
  final completer = Completer<void>();
  js.callMethod(methodName, [
    ...args,
    JsFunction.withThis((_) {
      completer.complete();
    })
  ]);
  return completer.future;
}

Future<T> jsCallbackToFuture1<T>(
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

Future<T> jsCallbackToFuture2<T>(
    JsObject js, String methodName, List<dynamic> args,
    {bool secondRet = false}) {
  final completer = Completer<T>();

  js.callMethod(methodName, [
    ...args,
    JsFunction.withThis((_, dynamic ret1, dynamic ret2) {
      completer.complete(ret2 as T);
    })
  ]);

  return completer.future;
}
