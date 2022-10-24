import 'package:flutter/material.dart';

import '../sq_app.dart';
import 'screen.dart';

class SQNavBar extends StatefulWidget {
  final List<Screen> screens;

  const SQNavBar(this.screens);

  @override
  State<SQNavBar> createState() => _SQNavBarState();
}

class _SQNavBarState extends State<SQNavBar> {
  late int initialIndex;

  @override
  void initState() {
    initialIndex = SQApp.selectedNavScreen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.screens.length > 1
        ? NavigationBar(
            onDestinationSelected: (int index) async {
              SQApp.selectedNavScreen = index;
              await widget.screens[SQApp.selectedNavScreen]
                  .go(context, replace: true);
              ScreenState.of(context).refreshScreen();
            },
            selectedIndex: initialIndex,
            surfaceTintColor: Colors.white,
            destinations: widget.screens
                .map((screen) => NavigationDestination(
                      icon: Icon(screen.icon ?? Icons.explore),
                      label: screen.title,
                    ))
                .toList(),
          )
        : Container();
  }
}
