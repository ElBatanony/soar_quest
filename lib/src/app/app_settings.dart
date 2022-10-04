import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';
import '../db/sq_doc.dart';
import '../db/sq_doc_field.dart';
import 'app.dart';

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
