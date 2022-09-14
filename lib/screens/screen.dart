import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final String title;

  const Screen(this.title, {super.key});

  @override
  State<Screen> createState() => ScreenState();
}

class ScreenState<T extends Screen> extends State<T> {
  void refreshScreen() => setState(() {});

  Widget screenBody(BuildContext context) {
    return Center(child: Text('${widget.title} Screen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: screenBody(context),
      ),
    );
  }
}
