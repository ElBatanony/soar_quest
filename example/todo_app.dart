import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

void main() async {
  await SQApp.init('Todo App');

  final tasks = LocalCollection(
    id: 'Todos',
    fields: [
      SQStringField('Name')..require = true,
      SQTimestampField('Date'),
      SQStringField('Description', maxLines: 3),
      SQBoolField('Completed')
        ..defaultValue = false
        ..editable = false
        ..show = inFormScreen.not,
      SQTimestampField('Completed Date')
        ..editable = false
        ..show = inFormScreen.not,
      SQBoolField('Repeat')..defaultValue = false,
      SQIntField('Repeat Every (Hours)')..show = DocValueCond('Repeat', true),
    ],
    actions: [
      SetFieldsAction('Mark as Complete',
          icon: Icons.done_rounded,
          show: DocValueCond('Completed', false),
          getFields: (doc) =>
              {'Completed': true, 'Completed Date': SQTimestamp.now()}),
      SetFieldsAction(
        'Unmark as Complete',
        icon: Icons.arrow_back,
        show: DocValueCond('Completed', true),
        getFields: (doc) => {'Completed': false},
      ),
    ],
  );

  final completedFilter = ValueFilter('Completed', true);
  final todoTasks = CollectionSlice(tasks, filter: completedFilter.inverse);
  final completedTasks = CollectionSlice(tasks,
      filter: completedFilter,
      sliceFields: ['Name', 'Completed Date', 'Completed']);

  SQApp.run([
    FormScreen(
      tasks.newDoc(),
      title: 'New Task',
      icon: Icons.add,
    ),
    CollectionScreen(
      title: 'My Tasks',
      collection: todoTasks,
      icon: Icons.add_task,
    ),
    CollectionScreen(
      title: 'Completed Tasks',
      collection: completedTasks,
      icon: Icons.task_alt,
    ),
    // TabsScreen('Tasks', screens: [
    //   CollectionScreen(title: 'Pending Tasks', collection: todoTasks),
    //   CollectionScreen(title: 'Completed Tasks', collection: completedTasks),
    // ]),
  ], startingScreen: 1);
}
