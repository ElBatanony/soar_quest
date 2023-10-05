import 'package:flutter/material.dart';

import '../mini_apps/mini_app.dart';
import '../sq_app.dart';
import '../ui/navbar.dart';

Future<T?> _goToScreen<T>(
  Screen screen,
  BuildContext context, {
  bool replace = false,
}) {
  SQApp.analytics?.setCurrentScreen(screen);

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

class Screen {
  Screen(
    this.title, {
    this.icon = Icons.stay_current_landscape,
    this.padding = const EdgeInsets.all(16),
    this.appbarEnabled = false,
  });

  final String title;
  IconData? icon;
  bool isInline = false;
  bool Function(BuildContext) show = alwaysShowScreen;
  bool appbarEnabled;

  late _ScreenState _myState;

  State<ScreenWidget> createState() => _myState = _ScreenState();

  BuildContext get context => _myState.context;
  bool get mounted => _myState.mounted;

  EdgeInsets padding;

  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      _goToScreen<T>(this, context, replace: replace);

  Future<T?> navigateTo<T extends Object?>(Screen targetScreen,
      {bool replace = false}) async {
    final ret = await _goToScreen<T>(targetScreen, context, replace: replace);
    refresh();
    return ret;
  }

  PreferredSizeWidget? appBar() => appbarEnabled
      ? AppBar(
          title: Text(title),
          leading: Navigator.of(context).canPop() ? const BackButton() : null,
          actions: appBarActions(),
        )
      : null;

  Widget screenBody() => Center(child: Text('$title Screen'));

  List<Widget> appBarActions() =>
      [IconButton(onPressed: refresh, icon: const Icon(Icons.refresh))];

  FloatingActionButton? floatingActionButton() => null;

  Widget? navigationBar() {
    if (SQApp.navbarScreens.length >= 2) return SQNavBar(SQApp.navbarScreens);
    return null;
  }

  @mustCallSuper
  void initScreen() {
    refreshBackButton();
    refreshMainButton();
  }

  @mustCallSuper
  void dispose() {}

  @mustCallSuper
  void refresh() {
    refreshBackButton();
    refreshMainButton();
    if (mounted) _myState.refreshScreen();
  }

  Widget toWidget() => ScreenWidget(this);

  void exitScreen<V extends Object?>([V? value]) {
    if (Navigator.canPop(context)) return Navigator.pop<V>(context, value);
  }

  EdgeInsetsGeometry? get screenPadding => isInline ? null : padding;

  Screen operator &(Screen other) => _CustomBodyScreen(title,
      bodyBuilder: () => Column(children: [toWidget(), other.toWidget()]));

  void refreshBackButton() {
    final backButton = MiniApp.backButton;
    if (Navigator.of(context).canPop()) {
      backButton.callback = exitScreen;
      if (backButton.isVisible == false) MiniApp.backButton.show();
    } else if (backButton.isVisible) {
      backButton.hide();
    }
  }

  void refreshMainButton() {
    if (MiniApp.mainButton.isVisible) MiniApp.mainButton.hide();
  }
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
  _CustomBodyScreen(super.title, {required this.bodyBuilder});

  final Widget Function() bodyBuilder;

  @override
  screenBody() => bodyBuilder();
}
