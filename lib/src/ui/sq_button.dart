import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final IconData? icon;
  final double iconSize;

  const SQButton(
    this.text, {
    required this.onPressed,
    Key? key,
  })  : icon = null,
        iconSize = 24,
        super(key: key);

  const SQButton.icon(
    this.icon, {
    this.text,
    required this.onPressed,
    this.iconSize = 24,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
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
}
