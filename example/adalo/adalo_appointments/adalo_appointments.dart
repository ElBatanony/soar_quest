import 'package:soar_quest/screens.dart';

import 'classes_screen.dart';
import 'config_adalo_appointments.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';
import 'teach_screen.dart';

void main() async {
  await adaloAppointmentsApp.init();

  adaloAppointmentsApp.run(MainScreen([
    classesCollectionScreen(),
    LearnScreen(),
    TeachScreen(),
    profileScreen()
    // CollectionScreen(collection: classTypes, docScreen: classTypeDocScreen),
  ]));
}
