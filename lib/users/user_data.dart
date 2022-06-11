import 'package:soar_quest/apps/app.dart';

class UserData {
  String userId;

  UserData({required this.userId});

  userDataPath() {
    return "${App.instance.getAppPath()}users/$userId/data/";
  }
}
