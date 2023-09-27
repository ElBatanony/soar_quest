import 'package:flutter/material.dart';

import '../data/user_settings.dart';
import '../screens/screen.dart';
import '../sq_app.dart';

class SQDrawer extends StatelessWidget {
  SQDrawer([List<Screen> screens = const []]) {
    this.screens.addAll(screens);
    if (UserSettings.initialized &&
        screens.any((screen) => screen.title == 'Settings') == false)
      this.screens.add(UserSettings.settingsScreen());
  }

  late final List<Screen> screens = [];

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                SQApp.name,
                style: const TextStyle(fontSize: 24),
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
