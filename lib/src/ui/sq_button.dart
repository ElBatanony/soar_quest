import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  const SQButton(this.text, {required this.onPressed})
      : icon = null,
        iconSize = 24;

  const SQButton.icon(this.icon,
      {required this.onPressed, this.text, this.iconSize = 24});

  final String? text;
  final void Function()? onPressed;
  final IconData? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        child: icon == null
            ? ElevatedButton(onPressed: onPressed, child: Text(text!))
            : text == null
                ? IconButton(
                    iconSize: iconSize, onPressed: onPressed, icon: Icon(icon))
                : ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon, size: iconSize),
                    label: Text(text!)),
      );
}
