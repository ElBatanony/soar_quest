import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection tasks;
late CollectionSlice pendingTasks, doneTasks;

void main() async {
  await SQApp.init("Task Manager",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  await UserSettings.setSettings([SQStringField("hai"), SQBoolField("Dope")]);

  var checkTaskAction = SetFieldsAction("Check",
      getFields: (doc) => {"Last Updated": SQTimestamp.now(), "Status": "Done"},
      show: (doc) => doc.getField("Status")?.value != "Done");

  var uncheckTaskAction = SetFieldsAction("UNCheck",
      getFields: (doc) => {"Status": "To-Do"},
      icon: Icons.arrow_back,
      show: (doc) => doc.getField("Status")?.value == "Done");

  tasks = FirestoreCollection(
    id: "Tasks",
    fields: [
      SQStringField("Task", require: true),
      SQEnumField(SQStringField("Status"),
          options: ["Done", "To-Do"],
          value: "To-Do"), // TODO: add Show IF condition
      SQBoolField("Repeat"),
      SQTimestampField("Due Date"),
      SQTimestampField("Last Updated"),
    ],
    actions: [checkTaskAction, uncheckTaskAction],
    adds: false,
  );

  // TODO: add concept of conditions to SQ. apply to show field later

  CollectionFilter doneFilter = ValueFilter("Status", "Done");
  doneTasks = CollectionSlice(tasks, filter: doneFilter, readOnly: true);
  pendingTasks = CollectionSlice(tasks, filter: doneFilter.inverse());

  SQApp.run(
      SQNavBar([
        FormScreen(
          tasks.newDoc(),
          title: "New Task",
          hiddenFields: ["Status"],
          icon: Icons.add,
        ),
        TabsScreen("Tasks", [
          CollectionScreen(
              title: "Pending Tasks", collection: pendingTasks, isInline: true),
          CollectionScreen(
              title: "Done", collection: doneTasks, isInline: true),
        ]),
        CollectionScreen(title: "Tasks 2", collection: tasks),
      ]),
      drawer: SQDrawer([]),
      startingScreen: 1);
}
