import 'package:flutter/material.dart';

import '../app.dart';
import '../data.dart';

import 'doc_edit_screen.dart';
import 'screen.dart';

// TODO: extend from docEditScreen
class SettingsScreen extends Screen {
  const SettingsScreen({String title = "Settings", super.key}) : super(title);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ScreenState<SettingsScreen> {
  SQDoc? settingsDoc;

  loadSettings() async {
    settingsDoc = App.instance.settings.settingsDoc;
    refreshScreen();
  }

  settingsUpdateCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Settings Updated"),
    ));
  }

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  Widget screenBody(BuildContext context) {
    return settingsDoc == null
        ? Text("Loading settings")
        : DocEditScreenBody(
            settingsDoc!,
            updateCallback: settingsUpdateCallback,
          );
  }
}
