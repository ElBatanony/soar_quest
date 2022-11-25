import 'package:flutter/material.dart';

import '../data/user_settings.dart';
import '../screens/screen.dart';
import '../sq_app.dart';
import '../sq_auth.dart';

class SQDrawer extends StatelessWidget {
  final List<Screen> screens;

  SQDrawer([this.screens = const []]) {
    if (UserSettings.initialized &&
        screens.any((screen) => screen.title == "Settings") == false)
      screens.add(UserSettings.settingsScreen());
    if (SQAuth.offline == false) screens.add(SQProfileScreen());
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
              .where((screen) => screen.show(context))
              .map((screen) => ListTile(
                    leading: Icon(screen.icon),
                    title: Text(screen.title),
                    onTap: () async => screen.go(context, replace: true),
                  )),
        ],
      ),
    );
  }
}
