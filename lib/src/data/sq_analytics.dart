import '../screens/screen.dart';

abstract class SQAnalytics {
  void init();

  Future<void> logEvent(String name, {Map<String, Object>? params});

  Future<void> setCurrentScreen(Screen screen);

  Future<void> setUserId(String id);
}
