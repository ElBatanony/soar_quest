import 'package:flutter/material.dart';

import '../sq_app.dart';
import '../ui/sq_navbar.dart';

Future<T?> _goToScreen<T>(
  Screen screen,
  BuildContext context, {
  bool replace = false,
}) {
  if (replace)
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

  return Navigator.push<T>(
      context, MaterialPageRoute(builder: (context) => screen));
}

bool alwaysShowScreen(BuildContext context) => true;

class Screen extends StatefulWidget {
  final String title;
  final IconData? icon;
  final bool isInline;
  final bool Function(BuildContext) show;

  const Screen(
    this.title, {
    this.isInline = false,
    this.icon = Icons.stay_current_landscape,
    this.show = alwaysShowScreen,
    super.key,
  });

  @override
  State<Screen> createState() => ScreenState();

  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      _goToScreen<T>(this, context, replace: replace);

  AppBar appBar(ScreenState screenState) {
    return AppBar(
      title: Text(title),
      leading: Navigator.of(screenState.context).canPop() ? BackButton() : null,
      actions: appBarActions(screenState),
    );
  }

  Widget screenBody(ScreenState screenState) {
    return Center(child: Text('$title Screen'));
  }

  List<Widget> appBarActions(ScreenState screenState) {
    return [
      IconButton(
          onPressed: screenState.refreshScreen, icon: Icon(Icons.refresh))
    ];
  }

  FloatingActionButton? floatingActionButton(ScreenState screenState) => null;

  Widget? bottomNavBar(ScreenState screenState) {
    if (SQApp.navbarScreens.length > 1) return SQNavBar(SQApp.navbarScreens);
    return null;
  }
}

class ScreenState<T extends Screen> extends State<T> {
  void refreshScreen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final Widget body = Builder(builder: (_) {
      return Container(
        padding: widget.isInline ? null : EdgeInsets.all(16.0),
        child: widget.screenBody(this),
      );
    });

    if (widget.isInline) return body;

    return Builder(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.appBar(this),
        drawer: SQApp.drawer,
        body: body,
        floatingActionButton: widget.floatingActionButton(this),
        bottomNavigationBar: widget.bottomNavBar(this),
      );
    });
  }

  static ScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<ScreenState>()!;
  }

  void exitScreen<V extends Object?>([V? value]) {
    if (Navigator.canPop(context)) return Navigator.pop<V>(context, value);
  }
}
