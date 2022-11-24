import 'package:flutter/material.dart';

import '../sq_app.dart';
import '../screens/screen.dart';

class SQNavBar extends StatelessWidget {
  final List<Screen> screens;
  final int initialIndex;

  List<Screen> visibleScreens(BuildContext context) =>
      screens.where((screen) => screen.show(context)).toList();

  SQNavBar(this.screens) : initialIndex = SQApp.selectedNavScreen;

  @override
  Widget build(BuildContext context) {
    if (SQApp.navbarScreens.length < 2) throw "Too few screens for SQNavBar";
    return NavigationBar(
      onDestinationSelected: (index) async {
        SQApp.selectedNavScreen = index;
        visibleScreens(context)[SQApp.selectedNavScreen]
            .go(context, replace: true);
      },
      selectedIndex: initialIndex,
      surfaceTintColor: Colors.white,
      destinations: visibleScreens(context)
          .map((screen) => NavigationDestination(
              icon: Icon(screen.icon), label: screen.title))
          .toList(),
    );
  }
}
