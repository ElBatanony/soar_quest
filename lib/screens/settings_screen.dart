import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/data/sq_doc.dart';

import 'doc_edit_screen.dart';
import 'screen.dart';

class SettingsScreen extends Screen {
  SettingsScreen({String title = "Settings", Key? key})
      : super(title, key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SQDoc? settingsDoc;

  loadSettings() async {
    await AppSettings.init();
    settingsDoc = AppSettings.settingsDoc;
    setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: settingsDoc == null
            ? Text("Loading settings")
            : DocEditScreenBody(
                settingsDoc!,
                updateCallback: settingsUpdateCallback,
              ));
  }
}
