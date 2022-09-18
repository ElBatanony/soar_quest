import 'package:flutter/material.dart';

import '../app.dart';

const appWidth = 500;

class AppDisplay extends StatefulWidget {
  final App app;

  const AppDisplay(this.app, {Key? key}) : super(key: key);

  @override
  State<AppDisplay> createState() => _AppDisplayState();
}

class _AppDisplayState extends State<AppDisplay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: widget.app.name,
        debugShowCheckedModeBanner: false,
        theme: widget.app.theme,
        home: widget.app.homescreen);
  }
}
