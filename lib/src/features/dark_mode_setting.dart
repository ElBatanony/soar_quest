import 'package:flutter/material.dart';

import '../../soar_quest.dart';

class SQDarkMode {
  static const ThemeMode _defaultMode = ThemeMode.light;

  static late SQEnumField<String> _setting;

  static bool initialized = false;

  static String get _settingValue => (UserSettings.initialized &&
          SQDarkMode.initialized)
      ? (UserSettings.getSetting<String>(_setting.name) ?? _defaultMode.name)
      : _defaultMode.name;

  static ThemeMode get themeMode =>
      ThemeMode.values.firstWhere((mode) => mode.name == _settingValue);

  static SQEnumField<String> setting(
      {ThemeMode defaultMode = _defaultMode, String name = 'Dark Mode'}) {
    SQDarkMode.initialized = true;
    return _setting = SQEnumField(
        SQStringField(name)..defaultValue = defaultMode.name,
        options: [
          ThemeMode.light.name,
          ThemeMode.dark.name,
          ThemeMode.system.name,
        ]);
  }
}
