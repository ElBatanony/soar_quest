import 'package:flutter/material.dart';

import 'app.dart';

class AppDisplay extends StatelessWidget {
  final App app;

  const AppDisplay(this.app, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app.name,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: app.homescreen,
    );
  }
}
