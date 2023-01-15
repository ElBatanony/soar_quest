import 'package:flutter/material.dart';

import '../screens/telegram_screen.dart';

class FeedbackScreen extends TelegramScreen {
  FeedbackScreen({
    required super.telegramUsername,
    String title = 'Feedback',
    super.message = 'Reach out to us!',
    super.buttonText = 'Send Feedback',
  }) : super(title, icon: Icons.feedback);
}
