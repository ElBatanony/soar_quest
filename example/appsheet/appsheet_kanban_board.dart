import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection workstreams, projects, tasks;

void main() async {
  List<SQField<dynamic>> userDocFields = [
    SQStringField("Name"),
    SQStringField("Role"),
    SQImageField("Photo"),
  ];

  await SQApp.init("Kanban Board",
      userDocFields: userDocFields,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  workstreams = FirestoreCollection(id: "Workstreams", fields: [
    SQStringField("Workstream"),
    SQStringField("test readonly", editable: false, value: "hamada"),
    SQEnumField(SQStringField("Color"),
        options: ["#4285F4", "#DB4437", "#F4B400", "#0F9D58"]),
    SQInverseRefsField("Related Projects",
        refCollection: () => projects, refFieldName: "Workstream"),
  ], actions: [
    GoEditCloneAction("Clone Workspace"),
    GoScreenAction("Go Empty",
        screen: (doc) => Screen("Empty Screen for ${doc.label}")),
    GoEditAction(name: "Edit Workspace"),
    CreateDocAction(
      "New Project",
      getCollection: () => projects,
      initialFields: (doc) => [
        SQRefField("Workstream", collection: workstreams, value: doc.ref),
        SQStringField("Project", value: "From Workstream ${doc.label}"),
      ],
    ),
    DeleteDocAction(name: "Delete Workflow"),
    ExecuteOnDocsAction("Make Project Hamada",
        getDocs: (doc) => [projects.docs[0]],
        action: SetFieldsAction("Status Hamada",
            getFields: (projectDoc) => {"Status": "Hamada"})),
    OpenUrlAction("Search",
        getUrl: (doc) => "https://www.google.com/search?q=${doc.label}"),
    CustomAction("Custom Action",
        customExecute: (doc, context) async =>
            showSnackBar("Hamada ${doc.label}", context: context)),
  ]);

  projects = FirestoreCollection(id: "Projects", fields: [
    SQStringField("Project"),
    SQRefField("Workstream", collection: workstreams),
    SQEnumField(SQStringField("Status"),
        options: ["Not Started", "In Progress", "Complete"]),
    SQInverseRefsField("Tasks",
        refCollection: () => tasks, refFieldName: "Project"),
  ]);

  tasks = FirestoreCollection(id: "Tasks", fields: [
    SQStringField("Task"),
    SQRefField("Project", collection: projects),
    SQEnumField(SQStringField("Status"), options: ["To-do", "Complete"]),
    SQUserRefField("Owner"),
  ]);

  SQApp.run([
    CollectionScreen(collection: workstreams),
    CollectionScreen(collection: projects),
    CollectionScreen(collection: tasks),
    ProfileScreen(),
  ]);
}
