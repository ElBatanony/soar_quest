import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection tasks;
late CollectionSlice pendingTasks, doneTasks;

void main() async {
  await SQApp.init("Task Manager",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

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
    actions: [
      SetFieldsAction("Check",
          getFields: (doc) => {
                "Last Updated": SQTimestamp.now(),
                "Status": "Done",
              })
    ],
    adds: false,
  );

  // TODO: add icons to actions
  // TODO: show/applicable condition to actions
  // TODO: add concept of conditions to SQ. apply to show field later
  // TODO: add confirmation message/bool to actions
  // TODO: close keyboard when click ok
  // TODO: add user setting

  CollectionFilter doneFilter = ValueFilter("Status", "Done");

  doneTasks = CollectionSlice(tasks, filter: doneFilter, readOnly: true);
  pendingTasks = CollectionSlice(tasks, filter: doneFilter.inverse());

  SQApp.run(
      SQNavBar([
        FormScreen(
          tasks.newDoc(),
          title: "New Task",
          hiddenFields: ["Status"],
        ),
        TabsScreen("Tasks", [
          CollectionScreen(
              title: "Pending Tasks", collection: pendingTasks, isInline: true),
          CollectionScreen(
              title: "Done", collection: doneTasks, isInline: true),
        ]),
        CollectionScreen(title: "Tasks 2", collection: tasks),
      ]),
      startingScreen: 1);
}
