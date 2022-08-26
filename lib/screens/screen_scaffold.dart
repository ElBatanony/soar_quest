import 'package:flutter/material.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/auth_manager.dart';

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const ScreenScaffold(this.title, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ShowIfAuthState(
              child: IconButton(
                  onPressed: AuthManager.signOut, icon: Icon(Icons.logout)))
        ],
      ),
      body: Center(child: child),
    );
  }
}

class ShowIfAuthState extends StatelessWidget {
  final bool showIfSignedIn;
  final Widget child;
  const ShowIfAuthState(
      {required this.child, this.showIfSignedIn = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: AuthManager.authChanges,
        builder: (context, snapshot) {
          return snapshot.data?["signedIn"] == true ? child : Container();
        });
  }
}

class ScaffoldedScreen extends Screen {
  final Widget screenBody;

  const ScaffoldedScreen(String title, {required this.screenBody, Key? key})
      : super(title, key: key);

  @override
  State<ScaffoldedScreen> createState() => _ScaffoldedScreenState();
}

class _ScaffoldedScreenState extends State<ScaffoldedScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      widget.title,
      widget.screenBody,
    );
  }
}
