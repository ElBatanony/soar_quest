import 'package:flutter/material.dart';

import 'screen.dart';

class TabsScreen extends Screen {
  TabsScreen(super.title, {required this.screens}) {
    for (final screen in screens) screen.isInline = true;
    appbarEnabled = true;
  }

  final List<Screen> screens;

  @override
  void refresh() {
    for (final screen in screens) screen.refresh();
    super.refresh();
  }

  @override
  Widget toWidget() => TabsScreenWidget(this, screens);

  Tab screenTab(Screen screen) => Tab(
        text: screen.title,
        icon: Icon(screen.icon),
      );
}

class TabsScreenWidget extends StatefulWidget {
  const TabsScreenWidget(this.tabsScreen, this.screens);

  final TabsScreen tabsScreen;
  final List<Screen> screens;

  @override
  State<TabsScreenWidget> createState() => _TabsScreenWidgetState();
}

class _TabsScreenWidgetState extends State<TabsScreenWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.screens.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(context) {
    final tabBar = TabBar(
      controller: tabController,
      isScrollable: true,
      onTap: (value) => tabController.animateTo(value),
      tabs: widget.screens
          .map((screen) => widget.tabsScreen.screenTab(screen))
          .toList(),
    );
    final PreferredSizeWidget appBar = PreferredSize(
      preferredSize: Size.fromHeight(tabBar.preferredSize.height),
      child: AppBar(
        toolbarHeight: tabBar.preferredSize.height,
        bottom: tabBar,
        elevation: 0,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: widget.tabsScreen.padding,
        child: TabBarView(
            controller: tabController,
            children: widget.screens.map((s) => s.toWidget()).toList()),
      ),
      floatingActionButton: widget.tabsScreen.floatingActionButton(),
      bottomNavigationBar: widget.tabsScreen.navigationBar(),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
