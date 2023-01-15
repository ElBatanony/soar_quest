import 'package:flutter/material.dart';

import 'screen.dart';

class TabsScreen extends Screen {
  TabsScreen(super.title, {required this.screens}) {
    for (final screen in screens) screen.isInline = true;
  }

  final List<Screen> screens;
  TabController? tabController;

  @override
  appBar() {
    if (tabController == null) return super.appBar();
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(onPressed: refresh, icon: const Icon(Icons.refresh))
      ],
      bottom: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        isScrollable: true,
        onTap: (value) => tabController?.animateTo(value),
        tabs: screens.map((screen) => Tab(text: screen.title)).toList(),
      ),
    );
  }

  @override
  Widget screenBody() => _StatefulTab(this);

  @override
  void dispose() {
    tabController?.dispose();
    tabController = null;
    super.dispose();
  }
}

class _StatefulTab extends StatefulWidget {
  const _StatefulTab(this.tabsScreen);

  final TabsScreen tabsScreen;

  @override
  State<_StatefulTab> createState() => _StatefulTabState();
}

class _StatefulTabState extends State<_StatefulTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.tabsScreen.tabController =
        TabController(length: widget.tabsScreen.screens.length, vsync: this);
    widget.tabsScreen.initScreen();
  }

  @override
  Widget build(context) => TabBarView(
      controller: widget.tabsScreen.tabController,
      children: widget.tabsScreen.screens.map((s) => s.toWidget()).toList());
}
