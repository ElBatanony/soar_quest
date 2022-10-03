import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/components/wrappers/signed_in_content.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/user_data.dart';
import 'package:soar_quest/screens.dart' hide createDoc;

void main() async {
  List<SQDocField> userDocFields = [SQStringField("Full Name")];

  App adaloTodoApp = App("To Do List",
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
      authManager: FirebaseAuthManager(),
      userDocFields: userDocFields);

  await adaloTodoApp.init();

  adaloTodoApp.run(MainScreen([
    TodoListScreen(
        title: "To Do List", tasksCollection: TasksCollection(id: "Tasks")),
    ProfileScreen(),
  ]));
}

class TasksCollection extends FirestoreCollection {
  TasksCollection({required super.id})
      : super(
            fields: [SQStringField("Name"), SQBoolField("Status")],
            parentDoc: App.userDoc,
            singleDocName: "Task");

  List<SQDoc> get todoTasks => docs.where((doc) => !isComplete(doc)).toList();

  List<SQDoc> get doneTasks => docs.where(isComplete).toList();

  Future completeTask(SQDoc taskDoc) {
    taskDoc.setDocFieldByName("Status", true);
    return saveDoc(taskDoc);
  }

  bool isComplete(SQDoc taskDoc) {
    return taskDoc.value("Status");
  }

  Future addTask(String taskName) {
    String newTaskDocId = getANewDocId();
    SQDoc newTaskDoc = SQDoc(newTaskDocId, collection: this);
    newTaskDoc.setDocFieldByName("Name", taskName);
    newTaskDoc.setDocFieldByName("Status", false);
    return createDoc(newTaskDoc);
  }
}

class TodoListScreen extends CollectionScreen {
  final TasksCollection tasksCollection;

  TodoListScreen({super.title, required this.tasksCollection, super.key})
      : super(collection: tasksCollection);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends CollectionScreenState<TodoListScreen> {
  addTask() async {
    dynamic newTaskName = await showFieldDialog(
        context: context, field: widget.collection.getFieldByName("Name")!);
    if (newTaskName != null) {
      await widget.tasksCollection.addTask(newTaskName);
      refreshScreen();
    }
  }

  completeTask(SQDoc taskDoc) async {
    await widget.tasksCollection.completeTask(taskDoc);
    refreshScreen();
  }

  deleteTask(SQDoc taskDoc) async {
    await widget.collection.deleteDoc(taskDoc.id);
    refreshScreen();
  }

  @override
  Widget docDisplay(SQDoc doc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.tasksCollection.isComplete(doc)
            ? IconButton(onPressed: () {}, icon: Icon(Icons.check_circle))
            : IconButton(
                onPressed: (() => completeTask(doc)),
                icon: Icon(Icons.circle_outlined)),
        Text(doc.identifier),
        IconButton(onPressed: (() => deleteTask(doc)), icon: Icon(Icons.delete))
      ],
    );
  }

  @override
  List<Widget> docsDisplay(BuildContext context) {
    final TextStyle listHeaderStyle = Theme.of(context).textTheme.headline4!;
    return [
      Text("To Do", style: listHeaderStyle),
      ...widget.tasksCollection.todoTasks.map(docDisplay).toList(),
      Divider(),
      Text("Done", style: listHeaderStyle),
      ...widget.tasksCollection.doneTasks.map(docDisplay).toList(),
    ];
  }

  @override
  Widget screenBody(BuildContext context) {
    return SignedInContent(
      builder: (BuildContext context, SignedInUser user) {
        return Column(
          children: [
            ...docsDisplay(context),
            SQButton("Add Task", onPressed: addTask),
          ],
        );
      },
    );
  }
}
