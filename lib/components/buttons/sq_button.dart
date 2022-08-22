import 'package:flutter/material.dart';

class SQButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const SQButton(this.text, {required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          child: Text(text),
          onPressed: () => onPressed(),
        ));
  }
}
