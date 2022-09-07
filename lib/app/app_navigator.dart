import 'package:flutter/material.dart';
import 'package:soar_quest/screens/screen.dart';

Future goToScreen(Screen screen, {required BuildContext context}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

Future replaceScreen(Screen screen, {required BuildContext context}) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void exitScreen(BuildContext context, {dynamic value}) {
  return Navigator.pop(context, value);
}
