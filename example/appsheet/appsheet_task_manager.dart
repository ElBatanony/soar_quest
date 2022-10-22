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
      show: DocValueCond("Status", "Done").not());

  var uncheckTaskAction = SetFieldsAction("UNCheck",
      getFields: (doc) => {"Status": "To-Do"},
      icon: Icons.arrow_back,
      show: DocValueCond("Status", "Done"));

  tasks = FirestoreCollection(
    id: "Tasks",
    fields: [
      SQStringField("Task", require: true),
      SQEnumField<String>(
        SQStringField("Status"),
        options: ["Done", "To-Do"],
        value: "To-Do",
        show: inFormScreen.not(),
      ),
      SQEditedByField("hamada user"),
      SQBoolField("Repeat"),
      SQIntField("Repeat Every (Hours)", show: DocValueCond("Repeat", true)),
      SQVirtualField(
        field: SQStringField("Hamada"),
        valueBuilder: (doc) => "hamada yo",
      ),
      SQTimestampField("Last Updated"),
    ],
    actions: [checkTaskAction, uncheckTaskAction],
    adds: false,
  );

  // TODO: add view types: Card, Deck, Gallery, Table (see where before), Onboarding
  // TODO: add groupBy status

  CollectionFilter doneFilter = ValueFilter("Status", "Done");
  doneTasks = CollectionSlice(tasks, filter: doneFilter, readOnly: true);
  pendingTasks = CollectionSlice(tasks, filter: doneFilter.inverse());

  SQApp.run(
      SQNavBar([
        FormScreen(
          tasks.newDoc(),
          title: "New Task",
          icon: Icons.add,
        ),
        TabsScreen("Tasks", [
          CollectionScreen(
              title: "Pending Tasks", collection: pendingTasks, isInline: true),
          CollectionScreen(
              title: "Done", collection: doneTasks, isInline: true),
        ]),
        CollectionScreen(title: "Tasks 2", collection: tasks),
        ProfileScreen(),
      ]),
      drawer: SQDrawer([]),
      startingScreen: 1);
}
