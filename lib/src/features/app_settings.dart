import '../auth/sq_auth.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../screens/screen.dart';
import '../screens/form_screen.dart';

class AppSettings {
  static SQCollection? _settingsCollection;
  static SQDoc? settingsDoc;
  static List<SQField> settingsFields = [];

  static setSettings(List<SQField> settings) {
    settingsFields = settings;
    _settingsCollection = FirestoreCollection(
        id: 'Settings', parentDoc: SQAuth.userDoc, fields: settingsFields);
    settingsDoc = SQDoc('default', collection: _settingsCollection!);
  }

  getSetting(String settingsName) {
    return settingsDoc?.value(settingsName);
  }

  static Screen settingsScreen() {
    if (settingsDoc == null) throw "Settings not initialized";
    return FormScreen(doc: settingsDoc!, title: "Settings");
  }
}
