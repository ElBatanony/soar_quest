import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const SQButton(this.text, {required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(3),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ));
  }
}
