import 'package:flutter/material.dart';

import '../screens/screen.dart';
import '../sq_app.dart';

class SQNavBar extends StatelessWidget {
  SQNavBar(this.screens) : initialIndex = SQApp.selectedNavScreen;

  final List<Screen> screens;
  final int initialIndex;

  List<Screen> visibleScreens(BuildContext context) =>
      screens.where((screen) => screen.show(context)).toList();

  @override
  Widget build(BuildContext context) {
    if (SQApp.navbarScreens.length < 2)
      throw Exception('Too few screens for SQNavBar');
    return NavigationBar(
      onDestinationSelected: (index) async {
        SQApp.selectedNavScreen = index;
        await visibleScreens(context)[SQApp.selectedNavScreen]
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
