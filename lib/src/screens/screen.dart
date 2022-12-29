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
        pageBuilder: (context, animation1, animation2) => screen.toWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

  return Navigator.push<T>(
      context, MaterialPageRoute(builder: (context) => screen.toWidget()));
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

  late _ScreenState _myState;

  State<ScreenWidget> createState() => _myState = _ScreenState();

  BuildContext get context => _myState.context;
  bool get mounted => _myState.mounted;

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

  Widget? navigationBar() {
    if (SQApp.navbarScreens.length >= 2) return SQNavBar(SQApp.navbarScreens);
    return null;
  }

  @mustCallSuper
  void initScreen() {}

  @mustCallSuper
  void dispose() {}

  @mustCallSuper
  void refresh() {
    if (mounted) _myState.refreshScreen();
  }

  Widget toWidget() => ScreenWidget(this);

  void exitScreen<V extends Object?>([V? value]) {
    if (Navigator.canPop(context)) return Navigator.pop<V>(context, value);
  }

  EdgeInsetsGeometry? get screenPadding =>
      isInline ? null : const EdgeInsets.all(16);

  Screen operator &(Screen other) => _CustomBodyScreen(
      title: title,
      bodyBuilder: (screenState) => Column(children: [this, other]));
}

class _ScreenState<S extends Screen> extends State<ScreenWidget<S>> {
  void refreshScreen() => setState(() {});

  S get _screen => widget.screen;

  @override
  void initState() {
    super.initState();
    _screen.initScreen();
  }

  @override
  void dispose() {
    _screen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screen.signedIn && SQAuth.isSignedIn == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_screen.title),
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
        bottomNavigationBar: _screen.navigationBar(),
      );
    }

    final Widget body = Builder(
        builder: (_) => Container(
              padding: _screen.screenPadding,
              child: _screen.screenBody(),
            ));

    if (_screen.isInline) return body;

    return Builder(
        builder: (_) => Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: _screen.appBar(),
              drawer: SQApp.drawer,
              body: body,
              floatingActionButton: _screen.floatingActionButton(),
              bottomNavigationBar: _screen.navigationBar(),
            ));
  }
}

class ScreenWidget<S extends Screen> extends StatefulWidget {
  const ScreenWidget(this.screen);

  final S screen;

  @override
  // ignore: no_logic_in_create_state
  createState() => screen.createState();
}

class _CustomBodyScreen extends Screen {
  const _CustomBodyScreen({required super.title, required this.bodyBuilder});

  final Widget Function(ScreenState) bodyBuilder;

  @override
  screenBody(screenState) => bodyBuilder(screenState);
}
