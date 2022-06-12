import 'package:flutter/material.dart';
import 'package:soar_quest/screens/screen_scaffold.dart';

import 'screen.dart';

class ScreenButton extends StatelessWidget {
  final Screen targetScreen;

  const ScreenButton(this.targetScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          },
          child: Text(targetScreen.title)),
    );
  }
}

class MenuScreen extends Screen {
  final List<Screen> screens;

  MenuScreen(String title, this.screens, {Key? key}) : super(title, key: key);

  @override
  State<Screen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        "Menu Screen",
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                widget.screens.map((screen) => ScreenButton(screen)).toList()));
  }
}
