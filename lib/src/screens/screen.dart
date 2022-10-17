import 'package:flutter/material.dart';

import '../sq_app.dart';

export 'sq_drawer.dart';

Future<T?> _goToScreen<T>(
  Screen screen,
  BuildContext context, {
  bool replace = false,
}) {
  if (replace)
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
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
  void refreshScreen() => setState(() {});

  Widget screenBody(BuildContext context) {
    return Center(child: Text('${widget.title} Screen'));
  }

  FloatingActionButton? floatingActionButton() => null;

  @override
  Widget build(BuildContext context) {
    final Widget body = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.isInline) Text(widget.title),
            if (widget.prebody != null) widget.prebody!(context),
            screenBody(context),
            if (widget.postbody != null) widget.postbody!(context),
          ],
        ),
      ),
    );

    if (widget.isInline) return body;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))
      ]),
      drawer: SQApp.drawer,
      body: body,
      floatingActionButton: floatingActionButton(),
    );
  }
}

void exitScreen<T extends Object?>(BuildContext context, {T? value}) {
  if (Navigator.canPop(context)) return Navigator.pop<T>(context, value);
}
