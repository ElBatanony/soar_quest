import 'package:soar_quest/app/app.dart';

class UserData {
  String userId;
  bool isAnonymous;

  UserData({required this.userId, required this.isAnonymous});

  userDataPath() {
    return "${App.instance.getAppPath()}users/$userId/data/";
  }
}
