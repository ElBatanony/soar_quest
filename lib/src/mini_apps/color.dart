import 'package:flutter/material.dart' show Color, Colors;
export 'package:flutter/material.dart' show Color;

enum MiniAppColorScheme { light, dark }

extension MiniAppColorExtension on Color {
  MiniAppColor toMiniAppColor() => MiniAppColor(toHex());
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
}

Color _hexToColor(dynamic hexString) {
  if (hexString is! String) return Colors.black;
  final hex = hexString.toUpperCase().replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

class MiniAppColor extends Color {
  MiniAppColor(dynamic hex) : super(_hexToColor(hex).value);

  @override
  String toString() => toHex();
}
