import '../../app.dart';
import '../../db.dart';

class AppSettings {
  late SQCollection _settingsCollection;
  late SQDoc settingsDoc;
  List<SQDocField> settingsFields;

  AppSettings({this.settingsFields = const []});

  Future init() async {
    _settingsCollection = FirestoreCollection(
        id: 'Settings', parentDoc: App.userDoc, fields: settingsFields);
    settingsDoc = SQDoc('settings', collection: _settingsCollection);
    await settingsDoc.loadDoc();
  }

  getSetting(String settingsName) {
    return settingsDoc.value(settingsName);
  }
}
