import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';

import 'screen.dart';

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
    return MaterialApp(
      title: App.instance.name,
      theme: App.instance.theme ??
          ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: widget.bottomNavScreens.length > 1
            ? NavigationBar(
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
              )
            : null,
        body: widget.bottomNavScreens[currentPageIndex],
      ),
    );
  }
}
