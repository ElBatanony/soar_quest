import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import '../screens/screen.dart';
import 'collections/local_collection.dart';

const _settingsCollectionId = 'Settings';
const _defaultSettingsDocId = 'default';

class UserSettings {
  static late SQCollection _settingsCollection;

  static bool initialized = false;
  static String? restartLink;

  static SQDoc get _settingsDoc =>
      _settingsCollection.docs
          .firstWhereOrNull((doc) => doc.id == _defaultSettingsDocId) ??
      _settingsCollection.newDoc(id: _defaultSettingsDocId);

  static Future<void> setSettings(List<SQField<dynamic>> settings,
      {String? restartLink}) async {
    _settingsCollection =
        LocalCollection(id: _settingsCollectionId, fields: settings);
    await _settingsCollection.loadCollection();
    initialized = true;
    UserSettings.restartLink = restartLink;
  }

  static T? getSetting<T>(String settingName) =>
      _settingsDoc.getValue<T>(settingName);

  static Screen settingsScreen() =>
      FormScreen(_settingsDoc, title: 'Settings', icon: Icons.settings);
}
