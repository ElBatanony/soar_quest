import 'package:flutter/material.dart';
// import 'package:soar_quest/app/app.dart';

class Screen extends StatefulWidget {
  final String title;

  Screen(this.title, {Key? key}) : super(key: key) {
    // App.instance.setScreen(this);
  }

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
          ],
        ),
      ),
    );
  }
}
