import 'package:cloud_firestore/cloud_firestore.dart';

import '../../mini_apps.dart';
import '../sq_app.dart';

class SQTelegramBot {
  static Future<void> sendMessage(String message) => FirebaseFirestore.instance
          .collection('Example Apps/${SQApp.name}/_bot')
          .add({
        'message': message,
        'chatId': MiniApp.user.id,
      });
}
