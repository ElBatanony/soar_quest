import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  const SQButton(
    this.text, {
    required this.onPressed,
    this.padding = 3,
  })  : icon = null,
        iconSize = 24;

  const SQButton.icon(this.icon,
      {required this.onPressed,
      this.text,
      this.iconSize = 24,
      this.padding = 3});

  final String? text;
  final void Function()? onPressed;
  final IconData? icon;
  final double iconSize;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final textWidget = text == null ? null : Text(text!);
    final iconWidget = icon == null ? null : Icon(icon, size: iconSize);
    return Container(
      padding: EdgeInsets.all(padding),
      child: iconWidget == null
          ? FilledButton(onPressed: onPressed, child: textWidget)
          : textWidget == null
              ? IconButton.filled(
                  iconSize: iconSize,
                  onPressed: onPressed,
                  icon: iconWidget,
                  color: Colors.white)
              : FilledButton.icon(
                  onPressed: onPressed, icon: iconWidget, label: textWidget),
    );
  }
}
