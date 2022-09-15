import '../app.dart';
import '../data/db.dart';

class AppSettings {
  late SQCollection _settingsCollection;
  late SQDoc settingsDoc;
  List<SQDocField> settingsFields;

  AppSettings({this.settingsFields = const []});

  Future init() async {
    _settingsCollection = FirestoreUserCollection(
        id: 'Settings', userId: App.auth.user.userId, fields: settingsFields);
    settingsDoc = SQDoc('settings', collection: _settingsCollection);
    await settingsDoc.loadDoc();
  }

  getSetting(String settingsName) {
    return settingsDoc.getFieldValueByName(settingsName);
  }
}
