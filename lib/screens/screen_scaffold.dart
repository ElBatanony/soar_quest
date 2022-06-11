import 'package:flutter/material.dart';

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const ScreenScaffold(this.title, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: child),
    );
  }
}
