import 'package:flutter/material.dart';

import '../sq_app.dart';
import '../screens/screen.dart';

class SQNavBar extends StatefulWidget {
  final List<Screen> screens;

  const SQNavBar(this.screens);

  @override
  State<SQNavBar> createState() => _SQNavBarState();
}

class _SQNavBarState extends State<SQNavBar> {
  late int initialIndex;

  List<Screen> get screens =>
      widget.screens.where((screen) => screen.show(context)).toList();

  @override
  void initState() {
    initialIndex = SQApp.selectedNavScreen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (SQApp.navbarScreens.length < 2) throw "Too few screens for SQNavBar";
    return NavigationBar(
      onDestinationSelected: (int index) {
        SQApp.selectedNavScreen = index;
        screens[SQApp.selectedNavScreen].go(context, replace: true);
      },
      selectedIndex: initialIndex,
      surfaceTintColor: Colors.white,
      destinations: screens
          .map((screen) => NavigationDestination(
              icon: Icon(screen.icon), label: screen.title))
          .toList(),
    );
  }
}
