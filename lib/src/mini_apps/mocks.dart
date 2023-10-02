import 'cloud_storage.dart';
import 'js.dart';

bool mocking = (webAppJsObject['initDataUnsafe'] as JsObject)['user'] == null;

void mockInitDataUnsafe() {
  final initDataUnsafe = webAppJsObject['initDataUnsafe'] as JsObject;
  initDataUnsafe['user'] = JsObject.jsify({'id': 99911, 'first_name': 'test'});
  initDataUnsafe['auth_date'] = '16000';
  initDataUnsafe['hash'] = 'XYZ';
}

class CloudStorageMock implements CloudStorage {
  CloudStorageMock();

  late final _map = <String, dynamic>{};

  @override
  late JsObject js;

  @override
  Future<void> setItem(String key, String value) async => _map[key] = value;

  @override
  Future<T?> getItem<T>(String key) async => _map[key] as T?;

  @override
  Future<List<dynamic>> getItems(List<String> keys) async =>
      keys.map((key) => _map[key]).toList();

  @override
  Future<void> removeItem(String key) async => _map.remove(key);

  @override
  Future<void> removeItems(List<String> keys) async =>
      _map.removeWhere((key, value) => keys.contains(key));

  @override
  Future<List<String>> getKeys() async => _map.keys.toList();
}
