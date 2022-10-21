import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final IconData? icon;

  const SQButton(this.text, {required this.onPressed, Key? key})
      : icon = null,
        super(key: key);

  const SQButton.icon(this.icon, {this.text, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: icon == null
          ? ElevatedButton(onPressed: onPressed, child: Text(text!))
          : text == null
              ? IconButton(onPressed: onPressed, icon: Icon(icon))
              : ElevatedButton.icon(
                  onPressed: onPressed, icon: Icon(icon), label: Text(text!)),
    );
  }
}
