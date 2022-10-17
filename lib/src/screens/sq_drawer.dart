import 'package:flutter/material.dart';

import '../sq_app.dart';
import 'screen.dart';

class SQDrawer extends StatelessWidget {
  final List<Screen> screens;

  const SQDrawer(this.screens);

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
                    title: Text(screen.title),
                    onTap: () => screen.go(context, replace: true),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
