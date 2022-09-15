import 'package:flutter/material.dart';

import '../../data/db.dart';

class BoolFieldDisplay extends StatelessWidget {
  final SQDocField field;
  final SQDoc doc;
  final Widget widgetWhenTrue;
  final Widget widgetWhenFalse;

  const BoolFieldDisplay(
      this.field, this.doc, this.widgetWhenTrue, this.widgetWhenFalse,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (field.value != true) return widgetWhenFalse;
    return widgetWhenTrue;
  }
}
