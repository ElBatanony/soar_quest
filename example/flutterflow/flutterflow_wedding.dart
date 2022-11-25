import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  await SQApp.init('Wedding App',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  // TODO: guest list
  // TODO: transportation page
  // TODO: wiki pages (use flutter_quill). maybe as a field (not page)
  // TODO: add maps (use flutter_map)

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
      const SocialFeed(title: 'Social Feed', icon: Icons.no_drinks),
    ],
    drawer: SQDrawer(const [FeedbackScreen(telegramUsername: 'batanony')]),
  );
}
