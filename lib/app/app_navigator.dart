import 'package:flutter/material.dart';
import 'package:soar_quest/screens/screen.dart';

void goToScreen(Screen screen, {required BuildContext context}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
