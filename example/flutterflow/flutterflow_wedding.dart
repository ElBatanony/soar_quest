import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  await SQApp.init('Wedding App',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  SQApp.run(
    [
      MenuScreen(screens: [
        const Screen(title: 'Transportation'),
        const Screen(title: 'Ceremony'),
        const Screen(title: 'Our Story'),
        TabsScreen(title: 'Wedding Party', screens: const [
          Screen(title: 'Bridesmaids', isInline: true),
          Screen(title: 'Groomsmen', isInline: true),
        ])
      ], title: 'Home'),
      const SocialFeedScreen(title: 'Social Feed', icon: Icons.no_drinks),
    ],
    drawer: SQDrawer(const [FeedbackScreen(telegramUsername: 'batanony')]),
  );
}
