import 'package:flutter/material.dart';

import '../sq_app.dart';
import '../sq_auth.dart';
import '../ui/button.dart';
import '../ui/navbar.dart';

Future<T?> _goToScreen<T>(
  Screen screen,
  BuildContext context, {
  bool replace = false,
}) {
  if (replace)
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

  return Navigator.push<T>(
      context, MaterialPageRoute(builder: (context) => screen));
}

bool alwaysShowScreen(BuildContext context) => true;

class Screen extends StatefulWidget {
  const Screen({
    required this.title,
    this.isInline = false,
    this.icon = Icons.stay_current_landscape,
    this.show = alwaysShowScreen,
    this.signedIn = false,
  });

  final String title;
  final IconData? icon;
  final bool isInline;
  final bool Function(BuildContext) show;
  final bool signedIn;

  @override
  State<Screen> createState() => ScreenState();

  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      _goToScreen<T>(this, context, replace: replace);

  PreferredSizeWidget appBar(ScreenState screenState) => AppBar(
        title: Text(title),
        leading: Navigator.of(screenState.context).canPop()
            ? const BackButton()
            : null,
        actions: appBarActions(screenState),
      );

  Widget screenBody(ScreenState screenState) =>
      Center(child: Text('$title Screen'));

  List<Widget> appBarActions(ScreenState screenState) => [
        IconButton(
            onPressed: screenState.refreshScreen,
            icon: const Icon(Icons.refresh))
      ];

  FloatingActionButton? floatingActionButton(ScreenState screenState) => null;

  Widget? navigationBar(ScreenState screenState) {
    if (SQApp.navbarScreens.length >= 2) return SQNavBar(SQApp.navbarScreens);
    return null;
  }

  EdgeInsetsGeometry? get screenPadding =>
      isInline ? null : const EdgeInsets.all(16);

  Screen operator &(Screen other) => _CustomBodyScreen(
      title: title,
      bodyBuilder: (screenState) => Column(children: [this, other]));
}

class ScreenState<T extends Screen> extends State<T> {
  void refreshScreen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (widget.signedIn && SQAuth.isSignedIn == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: SQApp.drawer,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You should be signed in to view this screen.'),
              SQButton('Sign In',
                  onPressed: () async => SQProfileScreen().go(context))
            ],
          ),
        ),
        bottomNavigationBar: widget.navigationBar(this),
      );
    }

    final Widget body = Builder(
        builder: (_) => Container(
              padding: widget.screenPadding,
              child: widget.screenBody(this),
            ));

    if (widget.isInline) return body;

    return Builder(
        builder: (_) => Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: widget.appBar(this),
              drawer: SQApp.drawer,
              body: body,
              floatingActionButton: widget.floatingActionButton(this),
              bottomNavigationBar: widget.navigationBar(this),
            ));
  }

  void exitScreen<V extends Object?>([V? value]) {
    if (Navigator.canPop(context)) return Navigator.pop<V>(context, value);
  }
}

class _CustomBodyScreen extends Screen {
  const _CustomBodyScreen({required super.title, required this.bodyBuilder});

  final Widget Function(ScreenState) bodyBuilder;

  @override
  screenBody(screenState) => bodyBuilder(screenState);
}
