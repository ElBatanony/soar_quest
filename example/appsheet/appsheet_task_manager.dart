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
      show: DocValueCond("Status", "Done").not);

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
        show: inFormScreen.not,
      ),
      // SQImageField("Image"),
      SQEditedByField("hamada user"),
      SQBoolField("Repeat", value: false),
      SQIntField("Repeat Every (Hours)", show: DocValueCond("Repeat", true)),
      SQTimestampField("Last Updated"),
    ],
    actions: [checkTaskAction, uncheckTaskAction],
    adds: true,
  );

  CollectionFilter doneFilter = ValueFilter("Status", "Done");
  doneTasks = CollectionSlice(tasks, filter: doneFilter, readOnly: true);
  pendingTasks = CollectionSlice(tasks, filter: doneFilter.inverse());

  SQApp.run([
    FormScreen(
      tasks.newDoc(),
      title: "New Task",
      icon: Icons.add,
    ),
    CardsScreen(collection: tasks),
    CollectionScreen(
      show: (context) => true,
      title: "Tasks 2",
      collection: tasks,
      groupBy: "Status",
    ),
    // CollectionFilterScreen(collection: tasks, filters: [
    //   StringContainsFilter(SQStringField("Task")),
    //   FieldValueFilter(SQBoolField("Repeat"))
    // ]),
    // TableScreen(title: "Table", collection: tasks),
    TabsScreen("Tasks", [
      CollectionScreen(
          title: "Pending Tasks", collection: pendingTasks, isInline: true),
      CollectionScreen(title: "Done", collection: doneTasks, isInline: true),
    ]),
  ], startingScreen: 1);
}
