import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/other_tools/webflow/elements/basic.dart';
import 'package:soar_quest/other_tools/webflow/elements/layout.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App webflowSiteApp = App("Webflow Site",
      inDebug: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true));

  webflowSiteApp.init();

  App.instance.currentUser = UserData(userId: "testuser123");

  webflowSiteApp.homescreen = MainScreen(
    [WebflowTestScreen("Webflow Test Screen")],
    initialScreenIndex: 0,
  );

  webflowSiteApp.run();
}

class WebflowTestScreen extends Screen {
  WebflowTestScreen(String title, {Key? key}) : super(title, key: key);

  @override
  State<WebflowTestScreen> createState() => _WebflowTestScreenState();
}

class _WebflowTestScreenState extends State<WebflowTestScreen> {
  @override
  Widget build(BuildContext context) {
    return WebflowSection(
      children: [
        WebflowContainer(
            children: [WebflowButton(buttonText: "Webflow Button")])
      ],
    );
  }
}
