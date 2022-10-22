import 'package:flutter/material.dart';

import '../sq_app.dart';

export 'sq_navbar.dart';
export 'sq_drawer.dart';

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

class Screen extends StatefulWidget {
  final String title;
  final Widget Function(BuildContext)? prebody;
  final Widget Function(BuildContext)? postbody;
  final IconData? icon;
  final bool isInline;

  const Screen(
    this.title, {
    this.prebody,
    this.postbody,
    this.isInline = false,
    this.icon,
    super.key,
  });

  @override
  State<Screen> createState() => ScreenState();

  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      _goToScreen<T>(this, context, replace: replace);
}

class ScreenState<T extends Screen> extends State<T> {
  void refreshScreen() => mounted ? setState(() {}) : {};

  Widget screenBody(BuildContext context) {
    return Center(child: Text('${widget.title} Screen'));
  }

  List<Widget> appBarActions(BuildContext context) {
    return [IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))];
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      leading: Navigator.of(context).canPop() ? BackButton() : null,
      actions: appBarActions(context),
    );
  }

  FloatingActionButton? floatingActionButton(BuildContext context) => null;

  Widget? bottomNavBar(BuildContext context) => SQApp.navbar;

  Widget inlineHeader(BuildContext context) => widget.isInline
      ? Text(widget.title, style: Theme.of(context).textTheme.titleLarge)
      : Container();

  @override
  Widget build(BuildContext context) {
    bool onlyBody = widget.prebody == null && widget.postbody == null;

    final Widget body = Builder(builder: (context2) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: onlyBody
            ? screenBody(context2)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    inlineHeader(context),
                    if (widget.prebody != null) widget.prebody!(context2),
                    screenBody(context2),
                    if (widget.postbody != null) widget.postbody!(context2),
                  ],
                ),
              ),
      );
    });

    if (widget.isInline) return body;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(context),
      drawer: SQApp.drawer,
      body: body,
      floatingActionButton: floatingActionButton(context),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  static ScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<ScreenState>()!;
  }

  void exitScreen<V extends Object?>([V? value]) {
    if (Navigator.canPop(context)) return Navigator.pop<V>(context, value);
  }
}
