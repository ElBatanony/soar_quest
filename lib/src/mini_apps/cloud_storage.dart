import 'js.dart';

class CloudStorage {
  CloudStorage(this.js);

  JsObject js;

  void setItem(String key, String value) =>
      js.callMethod('setItem', [sanitizeKey(key), value]);

  Future<T> getItem<T>(String key) =>
      jsCallbackToFuture(js, 'getItem', [sanitizeKey(key)]);

  Future<List<dynamic>> getItems(List<String> keys) =>
      jsCallbackToFuture(js, 'getItems', [keys.map(sanitizeKey).toList()]);

  void removeItem(String key) =>
      js.callMethod('removeItem', [sanitizeKey(key)]);

  Future<dynamic> removeItems(List<String> keys) =>
      jsCallbackToFuture(js, 'removeItems', [keys.map(sanitizeKey).toList()]);

  Future<List<String>> getKeys() async {
    final jsList =
        await jsCallbackToFuture<JsArray<dynamic>>(js, 'getKeys', []);
    return jsList.map((element) => element as String).toList();
  }

  String sanitizeKey(String key) {
    if (key.isEmpty || key.length > 128)
      throw ArgumentError('Key length must be between 1 and 128 characters.');

    final sanitizedKey = key.replaceAll(RegExp('[^A-Za-z0-9_-]'), '');

    if (sanitizedKey.isEmpty)
      throw ArgumentError('Key must contain at least one valid character.');

    return sanitizedKey;
  }
}
