import 'package:flutter/material.dart';

import 'screen.dart';

Future replaceScreen(Screen screen, {required BuildContext context}) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void exitScreen(BuildContext context, {dynamic value}) {
  if (Navigator.canPop(context)) return Navigator.pop(context, value);
}
