abstract class SQAnalytics {
  Future<void> logEvent(String name, {Map<String, dynamic>? params});

  void init();
}
