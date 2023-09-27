import 'package:soar_quest/soar_quest.dart';

void main() async {
  await SQApp.init('Wedding App');

  SQApp.run(
    [
      MenuScreen('Home', screens: [
        Screen('Transportation'),
        Screen('Ceremony'),
        Screen('Our Story'),
        TabsScreen('Wedding Party', screens: [
          Screen('Bridesmaids')..isInline = true,
          Screen('Groomsmen')..isInline = true,
        ])
      ]),
      SocialFeedScreen('Social Feed'),
    ],
    drawer: SQDrawer([FeedbackScreen(telegramUsername: 'batanony')]),
  );
}
