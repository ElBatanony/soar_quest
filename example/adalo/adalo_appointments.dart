import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/features/favourites/favourites.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

class FavouriteClassTypesFilter extends DocsFilter {
  FavouritesFeature favouritesFeature;

  FavouriteClassTypesFilter({required this.favouritesFeature});

  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final classes = docs;
    return classes.where((aclass) {
      SQDocReference classType = aclass.getFieldValueByName("Class Type");
      // print(classType);
      // print(favouritesFeature.favouritesCollection.favDocs);
      bool isClassInFavedType = favouritesFeature.favouritesCollection.favDocs
          .any((favedClassType) =>
              favedClassType.favedDocRef.docId == classType.docId);
      return isClassInFavedType;
    }).toList();
  }
}

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Full Name"),
    SQFileField("Profile Picture"),
  ];

  AppSettings settings = AppSettings(
      settingsFields: [SQBoolField("test field"), SQStringField("waow")]);

  App adaloAppointmentsApp = App("First Class",
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      settings: settings,
      userDocFields: userDocFields);

  await adaloAppointmentsApp.init();

  SQCollection classTypes =
      FirestoreCollection(id: "Class Types", fields: [SQStringField("Name")]);

  SQCollection classes = FirestoreCollection(
    id: "Classes",
    fields: [
      SQStringField("Name"),
      SQDocReferenceField("Class Type", collection: classTypes),
      SQUserRefField("Teacher"),
      SQIntField("Teacher's Years of Experience"),
    ],
  );

  SQCollection requests = FirestoreCollection(id: "Requests", fields: [
    SQDocReferenceField("Requested Class", collection: classes),
    SQTimestampField("Requested Class Date"),
    SQTimeOfDayField("Time"),
    SQStringField("Status", value: "Pending", readOnly: true),
    SQEditedByField("Attendee"),
    SQStringField("Video Meeting Link"),
    SQStringField("Reschedule Comment")
  ]);

  FavouritesFeature favouriteClassTypes =
      FavouritesFeature(collection: classTypes);

  DocScreen classTypeDocScreen(SQDoc doc) {
    return DocScreen(
      doc,
      postbody: (context) => Column(
        children: [
          favouriteClassTypes.addToFavouritesButton(doc),
          CollectionFilterScreen(collection: classes, filters: [
            DocRefFilter(
                docRefField: SQDocReferenceField("Class Type",
                    collection: doc.collection,
                    value: SQDocReference.fromDoc(doc)))
          ]).button(context)
        ],
      ),
    );
  }

  classes.docScreen = (doc) => ClassesDocScreen(doc, requests: requests);

  adaloAppointmentsApp.homescreen = MainScreen([
    CollectionFilterScreen(
      title: "Classes",
      collection: classes,
      filters: [
        FavouriteClassTypesFilter(
          favouritesFeature: favouriteClassTypes,
        )
      ],
      prebody: (_) => Column(
        children: [Text("Available Classes"), Text("Based On Your Interests")],
      ),
      postbody: (context) =>
          CollectionScreen(title: "All Classes", collection: classes)
              .button(context),
    ),
    LearnScreen(collection: requests),
    // CollectionScreen(collection: classTypes, docScreen: classTypeDocScreen),
    ProfileScreen(
      "Profile",
      postbody: (context) => FavouritesScreen(
        // TODO: make inline in profile
        favouritesFeature: favouriteClassTypes,
        docScreen: classTypeDocScreen,
        isInline: true,
        prebody: (context) => Row(
          children: [Text("Interested In")],
        ),
        postbody: (context) => CollectionFilterScreen(
            title: "Matching Classes",
            collection: classes,
            filters: [
              FavouriteClassTypesFilter(
                favouritesFeature: favouriteClassTypes,
              )
            ]).button(context),
      ),
    ),
  ]);

  adaloAppointmentsApp.run();
}

class ClassesDocScreen extends DocScreen {
  final SQCollection requests;

  ClassesDocScreen(super.doc, {required this.requests, super.key})
      : super(canEdit: false, canDelete: false);

  @override
  State<ClassesDocScreen> createState() => _BookClassScreenState();
}

class _BookClassScreenState extends DocScreenState<ClassesDocScreen> {
  @override
  Widget screenBody(BuildContext context) {
    return Column(children: [
      super.screenBody(context),
      SQButton(
        'Request Class',
        onPressed: () => goToScreen(
            DocCreateScreen(
              title: "Book Class",
              submitButtonText: "Submit Request",
              widget.requests,
              initialFields: [
                widget.requests.getFieldByName("Requested Class").copy()
                  ..value = SQDocReference.fromDoc(doc)
                  ..readOnly = true
              ],
              hiddenFields: [
                "Status",
                "Attendee",
                "Video Meeting Link",
                "Reschedule Comment"
              ],
            ),
            context: context),
      ),
    ]);
  }
}

class LearnScreen extends CollectionScreen {
  LearnScreen({required super.collection, super.key}) : super(title: "Learn");

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends CollectionScreenState<LearnScreen> {
  @override
  Widget docDisplay(SQDoc doc) {
    return LearnDocWidget(doc);
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        Text("My Upcoming Classes"),
        super.screenBody(context),
      ],
    );
  }
}

class LearnDocWidget extends StatefulWidget {
  final SQDoc doc;

  const LearnDocWidget(this.doc, {super.key});

  @override
  State<LearnDocWidget> createState() => _LearnDocWidgetState();
}

class _LearnDocWidgetState extends State<LearnDocWidget> {
  SQDoc? requestClassDoc;
  SQDocReference? teacherDocRef;

  void loadData() async {
    requestClassDoc =
        (widget.doc.getFieldValueByName("Requested Class") as SQDocReference)
            .getDoc();
    await requestClassDoc!.loadDoc();
    teacherDocRef = requestClassDoc!.getFieldValueByName("Teacher");
    setState(() {});
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SQDocReference classRef = widget.doc.getFieldValueByName("Requested Class");
    print(classRef.docId);
    return GestureDetector(
      onTap: () => goToScreen(DocScreen(widget.doc), context: context),
      child: Card(
        color: Colors.lightGreen[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.doc.identifier,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text("Status: ${widget.doc.getFieldValueByName("Status")}"),
              if (requestClassDoc?.initialized == true)
                Text("Teacher: ${teacherDocRef!.docIdentifier}"),
              Text(
                  "Requested Date: ${widget.doc.getFieldValueByName("Requested Class Date")}"),
            ],
          ),
        ),
      ),
    );
  }
}
