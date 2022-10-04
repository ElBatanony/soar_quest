import 'package:flutter/material.dart';

import 'screen.dart';

class MainScreen extends Screen {
  final List<Screen> bottomNavScreens;
  final int initialScreenIndex;

  const MainScreen(this.bottomNavScreens,
      {this.initialScreenIndex = 0, super.key})
      : super("App Main Screen");

  @override
  State<Screen> createState() => _MainScreenState();
}

class _MainScreenState extends ScreenState<MainScreen> {
  int currentPageIndex = 0;

  List<Screen> screens = [];

  @override
  void initState() {
    currentPageIndex = widget.initialScreenIndex;
    screens = widget.bottomNavScreens;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: screens.length > 1
          ? NavigationBar(
              onDestinationSelected: (int index) {
                currentPageIndex = index;
                refreshScreen();
              },
              selectedIndex: currentPageIndex,
              destinations: screens
                  .map((screen) => NavigationDestination(
                        icon: Icon(screen.icon ?? Icons.explore),
                        label: screen.title,
                      ))
                  .toList(),
            )
          : null,
      body: IndexedStack(index: currentPageIndex, children: screens),
    );
  }
}
