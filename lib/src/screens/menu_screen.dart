import 'package:flutter/material.dart';

import '../../screens.dart';

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

  const MenuScreen(String title, this.screens, {Key? key})
      : super(title, key: key);

  @override
  State<Screen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ScreenState<MenuScreen> {
  @override
  Widget screenBody(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            widget.screens.map((screen) => ScreenButton(screen)).toList());
  }
}
