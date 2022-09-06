import 'package:flutter/material.dart';

import 'app.dart';

class AppDebugger {
  static Function? refreshDebuggerDisplay;
  static AppDebugger? instance;
  static void refresh() {
    if (refreshDebuggerDisplay != null) refreshDebuggerDisplay!();
  }
}

class AppDebuggerDisplay extends StatefulWidget {
  const AppDebuggerDisplay({Key? key}) : super(key: key);

  @override
  State<AppDebuggerDisplay> createState() => _AppDebuggerDisplayState();
}

class _AppDebuggerDisplayState extends State<AppDebuggerDisplay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: App.instance.theme ??
            ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            title: Text("App Debugger"),
          ),
          body: AppDebuggerBody(),
        ));
  }
}

class AppDebuggerBody extends StatefulWidget {
  const AppDebuggerBody({Key? key}) : super(key: key);

  @override
  State<AppDebuggerBody> createState() => _AppDebuggerBodyState();
}

class _AppDebuggerBodyState extends State<AppDebuggerBody> {
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    AppDebugger.refreshDebuggerDisplay = refresh;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          children: [
            Text("App name: ${App.instance.name}"),
            Text(App.instance.currentScreen?.title ?? "no screen")
          ],
        ),
      ),
    );
  }
}
