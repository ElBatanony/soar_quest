import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final String title;
  final Widget? prebody;
  final Widget? postbody;

  const Screen(this.title, {this.prebody, this.postbody, super.key});

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
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (widget.prebody != null) widget.prebody!,
            screenBody(context),
            if (widget.postbody != null) widget.postbody!
          ],
        ),
      ),
    );
  }
}
