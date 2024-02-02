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
        text: screen.title.toUpperCase(),
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

  List<Screen> visibleScreens(BuildContext context) =>
      widget.screens.where((screen) => screen.show(context)).toList();

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
      onTap: (value) {
        tabController.animateTo(value);
        setState(() {});
      },
      tabs: visibleScreens(context)
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
            children:
                visibleScreens(context).map((s) => s.toWidget()).toList()),
      ),
      floatingActionButton:
          visibleScreens(context)[tabController.index].floatingActionButton(),
      bottomNavigationBar: widget.tabsScreen.navigationBar(),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
