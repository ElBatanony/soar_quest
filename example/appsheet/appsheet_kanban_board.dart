import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection workstreams, projects, tasks;

void main() async {
  final userDocFields = [
    SQStringField('Name'),
    SQStringField('Role'),
  ];

  await SQApp.init('Kanban Board',
      userDocFields: userDocFields,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  workstreams = LocalCollection(id: 'Workstreams', fields: [
    SQStringField('Workstream'),
    SQStringField('test readonly')
      ..defaultValue = 'hamada'
      ..editable = false,
    SQEnumField(SQStringField('Color'),
        options: ['#4285F4', '#DB4437', '#F4B400', '#0F9D58']),
    SQInverseRefsField('Related Projects',
        refCollection: () => projects, refFieldName: 'Workstream'),
  ], actions: [
    GoEditCloneAction('Clone Workspace'),
    GoScreenAction('Go Empty',
        toScreen: (doc) => Screen('Empty Screen for ${doc.label}')),
    GoEditAction(name: 'Edit Workspace'),
    CreateDocAction(
      'New Project',
      getCollection: () => projects,
      source: (doc) =>
          {'Workstream': doc.ref, 'Project': 'From Workstream ${doc.label}'},
    ),
    DeleteDocAction(name: 'Delete Workflow'),
    ExecuteOnDocsAction('Make Project Hamada',
        getDocs: (doc) => [projects.docs[0]],
        action: SetFieldsAction('Status Hamada',
            getFields: (projectDoc) => {'Status': 'Hamada'})),
    OpenUrlAction('Search',
        getUrl: (doc) => 'https://www.google.com/search?q=${doc.label}'),
    CustomAction('Custom Action',
        customExecute: (doc, screenState) async =>
            showSnackBar('Hamada ${doc.label}', context: screenState.context)),
  ]);

  projects = LocalCollection(id: 'Projects', fields: [
    SQStringField('Project'),
    SQRefField('Workstream', collection: workstreams),
    SQEnumField(SQStringField('Status'),
        options: ['Not Started', 'In Progress', 'Complete']),
    SQInverseRefsField('Tasks',
        refCollection: () => tasks, refFieldName: 'Project'),
  ]);

  tasks = LocalCollection(id: 'Tasks', fields: [
    SQStringField('Task'),
    SQRefField('Project', collection: projects),
    SQEnumField(SQStringField('Status'), options: ['To-do', 'Complete']),
    SQUserRefField('Owner'),
  ]);

  SQApp.run([
    CollectionScreen(collection: workstreams),
    CollectionScreen(collection: projects),
    CollectionScreen(collection: tasks),
    SQProfileScreen(),
  ]);
}
