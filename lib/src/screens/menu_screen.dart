import 'package:flutter/material.dart';

import '../ui/sq_button.dart';
import 'screen.dart';

class MenuScreen extends Screen {
  final List<Screen> screens;

  const MenuScreen({required this.screens, required super.title});

  @override
  Widget screenBody(ScreenState<Screen> screenState) {
    return ListView(
      children: [
        for (final screen in screens)
          SQButton(
            screen.title,
            onPressed: () async => screen.go(screenState.context),
          ),
      ],
    );
  }
}
