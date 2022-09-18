import 'package:flutter/material.dart';

import '../app.dart';
import '../components/buttons/sq_button.dart';

// TODO: add inline screen option
class Screen extends StatefulWidget {
  final String title;
  final Widget Function(BuildContext)? prebody;
  final Widget Function(BuildContext)? postbody;

  const Screen(this.title, {this.prebody, this.postbody, super.key});

  SQButton button(BuildContext context) {
    return SQButton('Go to $title',
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(onPressed: refreshScreen, icon: Icon(Icons.refresh))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (widget.prebody != null) widget.prebody!(context),
            screenBody(context),
            if (widget.postbody != null) widget.postbody!(context),
          ],
        ),
      ),
    );
  }
}
