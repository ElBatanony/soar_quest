import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

void main() async {
  await SQApp.init('Robin.do');

  final tasks = MiniAppCollection(id: 'Todos', fields: [
    SQStringField('Name'),
    SQTimestampField('Date'),
    SQStringField('Description', maxLines: 3),
    SQBoolField('Completed')
      ..defaultValue = false
      ..editable = false
      ..show = falseCond,
    SQTimestampField('Completed Date')
      ..editable = false
      ..show = inFormScreen.not,
  ], actions: [
    SetFieldsAction('Mark As Complete',
        icon: Icons.done_rounded,
        show: DocValueCond('Completed', false),
        getFields: (doc) =>
            {'Completed': true, 'Completed Date': SQTimestamp.now()})
  ]);

  final todoTasks =
      CollectionSlice(tasks, filter: ValueFilter('Completed', false));
  final completedTasks = CollectionSlice(tasks,
      filter: ValueFilter('Completed', true),
      sliceFields: ['Name', 'Completed Date', 'Completed']);

  SQApp.run([
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
  ]);
}
