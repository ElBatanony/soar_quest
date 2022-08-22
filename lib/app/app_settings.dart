import '../data.dart';
import '../data/firestore.dart';

class AppSettings {
  static SQDoc settingsDoc = SQDoc(
      'settings',
      [
        SQBoolField('testSetting'),
      ],
      collection: userCollection);

  static void setSettings(List<SQDocField> settings) {
    settingsDoc = SQDoc('settings', settings, collection: userCollection);
  }

  static Future init() async {
    await settingsDoc.loadDoc();
    return;
  }

  static getSetting(String settingsName) {
    return settingsDoc.getFieldValueByName(settingsName);
  }
}
