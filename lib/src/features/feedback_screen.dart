import 'package:flutter/material.dart';

import '../screens/telegram_screen.dart';

class FeedbackScreen extends TelegramScreen {
  const FeedbackScreen({
    required super.telegramUsername,
    super.title = 'Feedback',
    super.icon = Icons.feedback,
    super.message = 'Reach out to us!',
    super.buttonText = 'Send Feedback',
  });
}
