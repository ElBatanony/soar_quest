import '../app/app.dart';
import '../data.dart';

class UserData {
  String userId;
  bool isAnonymous;

  UserData({required this.userId, required this.isAnonymous});

  userDataPath() {
    return "${App.instance.getAppPath()}users/$userId/data/";
  }
}

List<SQDocField> userDocFields = [
  SQStringField("Nickname"),
  SQTimestampField("Birthdate")
];

late SQCollection userCollection;
late SQDoc userDoc;
