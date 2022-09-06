import 'package:flutter/material.dart';

class WebflowDivBlock {}

class WebflowList {}

class WebflowListItem {}

class WebflowLinkBlock {}

class WebflowButton extends StatelessWidget {
  final String buttonText;

  const WebflowButton({this.buttonText = "Button Text", Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(buttonText));
  }
}
