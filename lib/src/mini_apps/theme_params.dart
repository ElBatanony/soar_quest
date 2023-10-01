import 'package:flutter/material.dart';

import 'color.dart';
import 'js.dart';

export 'package:flutter/material.dart' show Brightness;

export 'color.dart';

class ThemeParams {
  ThemeParams(JsObject js, String colorSchemeString)
      : colorScheme =
            colorSchemeString == 'light' ? Brightness.light : Brightness.dark,
        bgColor = MiniAppColor(js['bg_color']),
        textColor = MiniAppColor(js['text_color']),
        hintColor = MiniAppColor(js['hint_color']),
        linkColor = MiniAppColor(js['link_color']),
        buttonColor = MiniAppColor(js['button_color']),
        buttonTextcolor = MiniAppColor(js['button_text_color']),
        secondaryBgColor = MiniAppColor(js['secondary_bg_color']);

  final Brightness colorScheme;

  final Color bgColor;
  final Color textColor;
  final Color hintColor;
  final Color linkColor;
  final Color buttonColor;
  final Color buttonTextcolor;
  final Color secondaryBgColor;

  // TODO: Match Material 3 ThemeData with Mini App ThemeParams
  ThemeData toMaterialThemeData() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: colorScheme,
          seedColor: buttonColor,
          background: bgColor,
        ),
      );
}
