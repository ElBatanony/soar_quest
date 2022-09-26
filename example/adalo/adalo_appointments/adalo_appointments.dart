import 'package:soar_quest/screens/main_screen.dart';

import 'classes_screen.dart';
import 'config_adalo_appointments.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';
import 'teach_screen.dart';

void main() async {
  await adaloAppointmentsApp.init();

  adaloAppointmentsApp.homescreen = MainScreen([
    classesCollectionScreen(),
    LearnScreen(),
    TeachScreen(),
    profileScreen()
    // CollectionScreen(collection: classTypes, docScreen: classTypeDocScreen),
  ]);

  adaloAppointmentsApp.run();
}
