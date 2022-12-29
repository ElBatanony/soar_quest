import 'package:flutter/material.dart';

import '../screens/telegram_screen.dart';

class SocialFeedScreen extends TelegramScreen {
  SocialFeedScreen(super.title)
      : super(
          message:
              'Soar Quest does not promote social feeds (posts, likes, etc.). '
              'We recommend using tools such as Telegram Channels'
              ' for such purposes.',
          telegramUsername: '',
          buttonText: 'Checkout Telegram',
        ) {
    icon = Icons.no_drinks;
  }
}
