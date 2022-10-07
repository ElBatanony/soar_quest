import 'package:flutter/material.dart';

import 'screen.dart';

class MainScreen extends Screen {
  final List<Screen> screens;
  final int initialScreenIndex;

  const MainScreen(this.screens, {this.initialScreenIndex = 0, super.key})
      : super("App Main Screen");

  @override
  State<Screen> createState() => _MainScreenState();
}

class _MainScreenState extends ScreenState<MainScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    currentPageIndex = widget.initialScreenIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.screens.length > 1
          ? NavigationBar(
              onDestinationSelected: (int index) {
                currentPageIndex = index;
                refreshScreen();
              },
              selectedIndex: currentPageIndex,
              destinations: widget.screens
                  .map((screen) => NavigationDestination(
                        icon: Icon(screen.icon ?? Icons.explore),
                        label: screen.title,
                      ))
                  .toList(),
            )
          : null,
      body: IndexedStack(index: currentPageIndex, children: widget.screens),
    );
  }
}
