import 'package:flutter/material.dart';

import '../ui/button.dart';
import 'screen.dart';

class MenuScreen extends Screen {
  MenuScreen(super.title, {required this.screens});

  final List<Screen> screens;

  @override
  Widget screenBody(ScreenState<Screen> screenState) => ListView(
        children: [
          for (final screen in screens)
            SQButton(
              screen.title,
              onPressed: () async => screen.go(screenState.context),
            ),
        ],
      );
}
