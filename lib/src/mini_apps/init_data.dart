import 'js.dart';
import 'user.dart';

class WebAppInitData {
  WebAppInitData(JsObject js, this.rawInitdata)
      : queryId = js['query_id'] as String?,
        user = WebAppUser(js['user'] as JsObject),
        chatType = js['chat_type'] as String?,
        chatInstance = js['chat_instance'] as String?,
        canSendAfter = js['can_send_after'] as int?,
        authDate = js['auth_date'] as String,
        hash = js['hash'] as String;

  String? queryId;
  WebAppUser user;
  String? chatType;
  String? chatInstance;
  int? canSendAfter;
  String authDate;
  String hash;
  String rawInitdata;
}
