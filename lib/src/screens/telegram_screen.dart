import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../ui/button.dart';
import 'screen.dart';

class TelegramButton extends SQButton {
  TelegramButton(String text, {required this.username})
      : super.icon(Icons.telegram,
            text: text, onPressed: () => openTelegramUrl(username));

  final String username;

  static Future<void> openTelegramUrl(String username) async {
    await launchUrlString(
      'https://t.me/$username',
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }
}

class TelegramScreen extends Screen {
  TelegramScreen(
    super.title, {
    required this.message,
    required this.telegramUsername,
    required this.buttonText,
    super.icon,
  });

  final String message;
  final String telegramUsername;
  final String buttonText;

  @override
  Widget screenBody(ScreenState<Screen> screenState) => Center(
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
