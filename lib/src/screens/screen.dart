import 'package:flutter/material.dart';

import '../ui/sq_button.dart';

export 'screen_navigation.dart';

Future _goToScreen(Screen screen, BuildContext context) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

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

  SQButton button(BuildContext context, {String? label}) {
    return SQButton(label ?? title, onPressed: () => go(context));
  }

  @override
  State<Screen> createState() => ScreenState();

  Future go(BuildContext context) => _goToScreen(this, context);
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
        child: (widget.prebody != null ||
                widget.postbody != null ||
                widget.isInline)
            ? Column(
                children: [
                  if (widget.isInline) Text(widget.title),
                  if (widget.prebody != null) widget.prebody!(context),
                  screenBody(context),
                  if (widget.postbody != null) widget.postbody!(context),
                ],
              )
            : screenBody(context),
      ),
    );

    if (widget.isInline) return body;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))
      ]),
      body: body,
      floatingActionButton: floatingActionButton(),
    );
  }
}
