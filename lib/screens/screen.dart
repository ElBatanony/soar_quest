import 'package:flutter/material.dart';

import '../app.dart';
import '../components/buttons/sq_button.dart';

// TODO: create a barrel file for screens

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
    return SQButton(label ?? 'Go to $title',
        onPressed: () => goToScreen(this, context: context));
  }

  @override
  State<Screen> createState() => ScreenState();
}

class ScreenState<T extends Screen> extends State<T> {
  void refreshScreen() => setState(() {});

  Widget screenBody(BuildContext context) {
    return Center(child: Text('${widget.title} Screen'));
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.prebody != null) widget.prebody!(context),
            screenBody(context),
            if (widget.postbody != null) widget.postbody!(context),
          ],
        ),
      ),
    );

    if (widget.isInline) return body;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))
      ]),
      body: body,
    );
  }
}
