import 'package:soar_quest/screens/main_screen.dart';

import 'classes_screen.dart';
import 'config.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';

void main() async {
  await adaloAppointmentsApp.init();

  adaloAppointmentsApp.homescreen = MainScreen([
    classesCollectionScreen(
        classes: classes, favouriteClassTypes: favouriteClassTypes),
    LearnScreen(collection: requests),
    // CollectionScreen(collection: classTypes, docScreen: classTypeDocScreen),
    profileScreen(classes: classes, favouriteClassTypes: favouriteClassTypes)
  ]);

  adaloAppointmentsApp.run();
}
