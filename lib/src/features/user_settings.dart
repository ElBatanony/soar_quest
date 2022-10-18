import '../auth/sq_auth.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../screens/screen.dart';
import '../screens/form_screen.dart';

class UserSettings {
  static SQCollection? _settingsCollection;
  static SQDoc? _settingsDoc;

  static bool get initialized => _settingsDoc?.initialized ?? false;

  static void setSettings(List<SQField<dynamic>> settings) {
    _settingsCollection = FirestoreCollection(
        id: 'Settings', parentDoc: SQAuth.userDoc, fields: settings);
    _settingsDoc = SQDoc('default', collection: _settingsCollection!);
  }

  T? getSetting<T>(String settingName) => _settingsDoc?.value(settingName);

  static Screen settingsScreen() {
    if (_settingsDoc == null) throw "Settings not initialized";
    return FormScreen(_settingsDoc!, title: "Settings");
  }
}
