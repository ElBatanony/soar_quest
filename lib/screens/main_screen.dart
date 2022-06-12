import 'package:flutter/material.dart';

import 'screen.dart';

const appWidth = 500;

class MainScreen extends Screen {
  final List<Screen> bottomNavScreens;
  final int initialScreenIndex;

  const MainScreen(this.bottomNavScreens,
      {this.initialScreenIndex = 0, Key? key})
      : super("App Main Screen", key: key);

  @override
  State<Screen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    currentPageIndex = widget.initialScreenIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - appWidth,
          child: Scaffold(
            body: Text("App debug details here"),
          ),
        ),
        Expanded(
          child: Scaffold(
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: widget.bottomNavScreens
                  .map((screen) => NavigationDestination(
                        icon: Icon(Icons.explore),
                        label: screen.title,
                      ))
                  .toList(),
            ),
            body: widget.bottomNavScreens[currentPageIndex],
          ),
        ),
      ],
    );
  }
}
