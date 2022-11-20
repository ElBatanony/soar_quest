import 'package:flutter/material.dart';

import 'screen.dart';

class TabsScreen extends Screen {
  final List<Screen> screens;

  TabsScreen({required super.title, required this.screens})
      : assert(screens.every((screen) => screen.isInline));

  @override
  createState() => _TabsScreenState();

  @override
  AppBar appBar(ScreenState screenState) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
            onPressed: screenState.refreshScreen, icon: Icon(Icons.refresh))
      ],
      bottom: TabBar(
        controller: (screenState as _TabsScreenState)._tabController,
        labelColor: Colors.black,
        isScrollable: true,
        onTap: (value) => screenState._tabController.animateTo(value),
        tabs: screens.map((screen) => Tab(text: screen.title)).toList(),
      ),
    );
  }

  @override
  Widget screenBody(ScreenState screenState) {
    return TabBarView(
        controller: (screenState as _TabsScreenState)._tabController,
        children: screens);
  }
}

class _TabsScreenState extends ScreenState<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.screens.length, vsync: this);
    super.initState();
  }
}
