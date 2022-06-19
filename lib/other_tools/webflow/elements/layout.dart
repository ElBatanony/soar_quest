import 'package:flutter/material.dart';

class WebflowSection extends StatelessWidget {
  final List<Widget> children;
  const WebflowSection({this.children = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class WebflowContainer extends StatelessWidget {
  final List<Widget> children;
  const WebflowContainer({this.children = const [], Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(children: children));
  }
}

class WebflowGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns, rows;
  const WebflowGrid(
      {this.children = const [], this.columns = 2, this.rows = 2, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Grid Height Issues");
  }
}

class WebflowColumns {}
