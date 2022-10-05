import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../screens/form_screens/doc_edit_screen.dart';
import '../screens/screen.dart';
import 'app.dart';

// TODO: make AppSettings a feature, not integral part of app

class AppSettings {
  late SQCollection _settingsCollection;
  late SQDoc settingsDoc;
  List<SQField> settingsFields;

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

Screen settingsScreen() {
  return docEditScreen(App.instance.settings.settingsDoc, title: "Settings");
}
