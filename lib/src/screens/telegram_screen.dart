import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'screen.dart';
import '../ui/sq_button.dart';

class TelegramButton extends SQButton {
  final String username;

  static void openTelegramUrl(String username) async {
    launchUrlString(
      "https://t.me/$username",
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  TelegramButton(String text, {required this.username})
      : super.icon(Icons.telegram,
            text: text, onPressed: () => openTelegramUrl(username));
}

class TelegramScreen extends Screen {
  final String message;
  final String telegramUsername;
  final String buttonText;

  const TelegramScreen({
    required super.title,
    required this.message,
    required this.telegramUsername,
    required this.buttonText,
    super.icon,
  });

  @override
  Widget screenBody(ScreenState<Screen> screenState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(screenState.context).textTheme.bodyLarge,
          ),
          TelegramButton(buttonText, username: telegramUsername)
        ],
      ),
    );
  }
}
