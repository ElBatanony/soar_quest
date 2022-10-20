import 'package:flutter/material.dart';

import '../sq_app.dart';
import 'screen.dart';
import '../db/user_settings.dart';

class SQDrawer extends StatelessWidget {
  final List<Screen> screens;

  SQDrawer(this.screens) {
    if (UserSettings.initialized &&
        screens.any((screen) => screen.title == "Settings") == false)
      screens.add(UserSettings.settingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              SQApp.name,
              style: TextStyle(fontSize: 24),
            ),
          ),
          ...screens
              .map((screen) => ListTile(
                    leading: Icon(screen.icon),
                    title: Text(screen.title),
                    onTap: () => screen.go(context, replace: true),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
