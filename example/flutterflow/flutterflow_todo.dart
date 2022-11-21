import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  await SQApp.init("Robin.do",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  final tasks =
      FirestoreCollection(id: "Todos", parentDoc: SQAuth.userDoc, fields: [
    SQStringField("Name"),
    SQTimestampField("Date"),
    SQStringField("Description", maxLines: 3),
    SQBoolField("Completed", value: false, editable: false, show: falseCond),
    SQTimestampField("Completed Date",
        value: null, editable: false, show: inFormScreen.not),
    SQEditedByField("User", show: falseCond),
  ], actions: [
    SetFieldsAction("Mark As Complete",
        icon: Icons.done_rounded,
        show: DocValueCond("Completed", false),
        getFields: (doc) =>
            {"Completed": true, "Completed Date": SQTimestamp.now()})
  ]);

  final todoTasks =
      CollectionSlice(tasks, filter: ValueFilter("Completed", false));
  final completedTasks = CollectionSlice(tasks,
      filter: ValueFilter("Completed", true),
      sliceFields: ["Name", "Completed Date", "Completed"]);

  SQApp.run([
    CollectionScreen(
      title: "My Tasks",
      collection: todoTasks,
      icon: Icons.add_task,
      signedIn: true,
    ),
    CollectionScreen(
      title: "Completed Tasks",
      collection: completedTasks,
      icon: Icons.task_alt,
      signedIn: true,
    ),
  ], drawer: SQDrawer([]));
}
