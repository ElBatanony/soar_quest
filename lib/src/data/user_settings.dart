import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../sq_auth.dart';
import 'collections/local_collection.dart';

const _settingsCollectionId = 'Settings';
const _defaultSettingsDocId = 'default';

class UserSettings {
  static late SQCollection _settingsCollection;

  static bool initialized = false;

  static SQDoc get _settingsDoc {
    return _settingsCollection.docs
            .firstWhereOrNull((doc) => doc.id == _defaultSettingsDocId) ??
        _settingsCollection.newDoc(id: _defaultSettingsDocId);
  }

  static Future<void> setSettings(List<SQField<dynamic>> settings) async {
    _settingsCollection = LocalCollection(
        id: _settingsCollectionId, parentDoc: SQAuth.userDoc, fields: settings);
    await _settingsCollection.loadCollection();
    initialized = true;
  }

  T? getSetting<T>(String settingName) => _settingsDoc.value(settingName);

  static Screen settingsScreen() {
    return FormScreen(_settingsDoc, title: 'Settings', icon: Icons.settings);
  }
}
