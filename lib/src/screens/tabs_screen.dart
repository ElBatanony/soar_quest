import 'package:flutter/material.dart';

import 'screen.dart';

class TabsScreen extends Screen {
  final List<Screen> screens;

  TabsScreen(super.title, this.screens)
      : assert(screens.every((screen) => screen.isInline));

  @override
  createState() => _TabsScreenState();
}

class _TabsScreenState extends ScreenState<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.screens.length, vsync: this);
    super.initState();
  }

  @override
  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))
      ],
      bottom: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        isScrollable: true,
        onTap: (value) => tabController.animateTo(value),
        tabs: widget.screens.map((screen) => Tab(text: screen.title)).toList(),
      ),
    );
  }

  @override
  Widget screenBody(context) {
    return TabBarView(controller: tabController, children: widget.screens);
  }
}
