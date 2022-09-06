import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_debugger.dart';

import 'app.dart';

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
        theme: widget.app.theme ??
            ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: widget.app.inDebug
            ? Row(children: [
                Expanded(
                  child: AppDebuggerDisplay(),
                ),
                SizedBox(
                  width: appWidth.toDouble(),
                  child: widget.app.homescreen!,
                )
              ])
            : widget.app.homescreen!);
  }
}
