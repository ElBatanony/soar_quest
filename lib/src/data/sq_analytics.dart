import 'package:firebase_analytics/firebase_analytics.dart';

abstract class SQAnalytics {
  Future<void> logEvent(String name, {Map<String, dynamic>? params});

  void init();
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
}
