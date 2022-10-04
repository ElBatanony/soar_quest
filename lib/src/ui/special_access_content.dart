import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/user_data.dart';

class SpecialAccessContent extends StatefulWidget {
  final Widget child;
  final bool Function(UserData user) checker;

  const SpecialAccessContent(
      {required this.child, required this.checker, super.key});

  @override
  State<SpecialAccessContent> createState() => _SpecialAccessContentState();
}

class _SpecialAccessContentState extends State<SpecialAccessContent> {
  @override
  Widget build(BuildContext context) {
    return widget.checker(App.auth.user)
        ? Text("You do not have access to this content")
        : widget.child;
  }
}
