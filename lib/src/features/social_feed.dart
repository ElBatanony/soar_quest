import '../screens/telegram_screen.dart';

class SocialFeedScreen extends TelegramScreen {
  const SocialFeedScreen({required super.title, super.icon})
      : super(
          message:
              'Soar Quest does not promote social feeds (posts, likes, etc.). '
              'We recommend using tools such as Telegram Channels'
              ' for such purposes.',
          telegramUsername: '',
          buttonText: 'Checkout Telegram',
        );
}