import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../screens/screen.dart';
import '../ui/sq_button.dart';

class SocialFeed extends Screen {
  const SocialFeed({required super.title, super.icon});

  @override
  Widget screenBody(ScreenState<Screen> screenState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Soar Quest does not promote social feeds (posts, likes, etc.). "
          "We recommend using tools such as Telegram Channels for such purposes.",
          textAlign: TextAlign.center,
          style: Theme.of(screenState.context).textTheme.bodyLarge,
        ),
        SQButton(
          "View Telegram Channels",
          onPressed: () => launchUrlString("https://tlgrm.eu/channels",
              mode: LaunchMode.externalApplication),
        ),
      ],
    );
  }
}
