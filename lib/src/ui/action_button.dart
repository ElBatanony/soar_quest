import 'package:flutter/material.dart';

import '../data/sq_action.dart';
import '../data/sq_doc.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import 'button.dart';

class SQActionButton extends StatefulWidget {
  const SQActionButton({
    required this.action,
    required this.doc,
    required this.screen,
    this.isIcon = false,
    this.iconSize = 24.0,
  });

  final SQAction action;
  final bool isIcon;
  final SQDoc doc;
  final double iconSize;
  final Screen screen;

  @override
  State<SQActionButton> createState() => _SQActionButtonState();
}

class _SQActionButtonState extends State<SQActionButton> {
  late bool inForm;

  @override
  void initState() {
    inForm = widget.screen is FormScreen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (inForm) return Container();

    return SQButton.icon(
      widget.action.icon,
      iconSize: widget.iconSize,
      text: widget.isIcon
          ? null
          : widget.action.name.isEmpty
              ? null
              : widget.action.name,
      onPressed: () async {
        final isConfirmed = widget.action.confirm == false ||
            await showConfirmationDialog(
                action: widget.action, context: context);
        if (isConfirmed)
          return widget.action.execute(widget.doc, widget.screen);
      },
    );
  }
}
