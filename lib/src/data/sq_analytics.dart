import 'package:firebase_analytics/firebase_analytics.dart';

import '../screens/screen.dart';

abstract class SQAnalytics {
  void init();

  Future<void> logEvent(String name, {Map<String, Object>? params});

  Future<void> setCurrentScreen(Screen screen);

  Future<void> setUserId(String id);
}

class SQFirebaseAnalytics extends SQAnalytics {
  @override
  void init() {
    _instance = FirebaseAnalytics.instance;
  }

  late FirebaseAnalytics _instance;

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) =>
      _instance.logEvent(name: name, parameters: params);

  @override
  Future<void> setCurrentScreen(Screen screen) =>
      _instance.setCurrentScreen(screenName: screen.title);

  @override
  Future<void> setUserId(String id) => _instance.setUserId(id: id);
}
