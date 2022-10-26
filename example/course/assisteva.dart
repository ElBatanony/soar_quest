import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

bool isAdmin = false;

late SQCollection lessons;

void main() async {
  await SQApp.init("Assisteva",
      theme:
          ThemeData(primaryColor: Colors.deepPurpleAccent, useMaterial3: true),
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  await UserSettings.setSettings([
    SQEnumField(SQStringField("Disability", value: "Normal"),
        options: ["Normal", "Blind", "Deaf"])
  ]);

  SQCollection categories = FirestoreCollection(
      id: "Categories",
      fields: [
        SQStringField("Name"),
        SQImageField("Picture"),
      ],
      readOnly: !isAdmin);

  SQRefField courseCategoryRefField =
      SQRefField("Category", collection: categories);

  SQCollection courses = FirestoreCollection(
    id: "Courses",
    fields: [
      SQStringField("Course Name"),
      SQStringField("Course Description"),
      courseCategoryRefField,
    ],
    actions: [
      GoScreenAction("View Lessons",
          screen: (doc) => CollectionScreen(
              collection: CollectionSlice(lessons,
                  filter: DocRefFilter("Course", doc.ref))))
    ],
    readOnly: !isAdmin,
  );

  lessons = FirestoreCollection(
    id: "Lessons",
    fields: [
      SQStringField("Lesson Name"),
      SQStringField("Lesson Description"),
      SQRefField("Course", collection: courses),
      VideoLinkField("Video Link"),
    ],
    readOnly: !isAdmin,
  );

  SQApp.run(
    SQNavBar([
      CategorySelectScreen(
        title: "Categories",
        collection: courses,
        categoryField: courseCategoryRefField,
      ),
      CollectionScreen(
        collection: categories,
        show: (context) => isAdmin,
      ),
      CollectionScreen(
        collection: courses,
        show: (context) => isAdmin,
      ),
      CollectionScreen(collection: lessons, show: (context) => isAdmin),
      if (!isAdmin) UserSettings.settingsScreen()
    ]),
    drawer: SQDrawer([ProfileScreen()]),
  );
}
