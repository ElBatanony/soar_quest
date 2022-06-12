import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/components/doc_field_toggle_buttons.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App todoistApp = App("Todoist");
  App.instance.currentUser = UserData(userId: "testuser123");

  final catalogueCollection = SQCollection(
      "Todos",
      [
        SQDocField("Task Name", SQDocFieldType.string),
        SQDocField("Reminder", SQDocFieldType.string),
        SQDocField("Done", SQDocFieldType.bool, value: false),
      ],
      userData: true);

  final todosScreen = CollectionScreen(
    "Todos",
    catalogueCollection,
    docScreenBody: TodoDocBody.new,
  );

  final MainScreen homescreen = MainScreen(
    [todosScreen, Screen("hello")],
    initialScreenIndex: 0,
  );
  todoistApp.homescreen = homescreen;

  todoistApp.run();
}

class TodoDocBody extends DocScreenBody {
  const TodoDocBody(SQDoc doc, {Key? key}) : super(doc, key: key);

  @override
  State<TodoDocBody> createState() => _TodoDocBodyState();
}

class _TodoDocBodyState extends State<TodoDocBody> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
          "Your task ${widget.doc.getFieldValueByName("Task Name")} is due on ${widget.doc.getFieldValueByName("Reminder")}"),
      Text("Done: ${widget.doc.getFieldValueByName("Done")}"),
      DocFieldToggleButtons(
          widget.doc.getFieldByName("Done"), widget.doc, refresh)
    ]);
  }
}