import 'js.dart';

class WebAppUser {
  WebAppUser(JsObject js)
      : id = js['id'] as int,
        firstName = js['first_name'] as String,
        lastName = js['last_name'] as String?,
        username = js['username'] as String?,
        languageCode = js['language_code'] as String?,
        isPremium = (js['is_premium'] as bool?) ?? false,
        allowsWriteToPm = (js['allows_write_to_pm'] as bool?) ?? false;

  int id;
  String firstName;
  String? lastName;
  String? username;
  String? languageCode;
  bool? isPremium;
  bool? allowsWriteToPm;
}
