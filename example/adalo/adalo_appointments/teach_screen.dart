import 'package:flutter/material.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_edit_screen.dart';

import 'config.dart';

class TeachScreen extends CollectionScreen {
  TeachScreen({super.key})
      : super(
          title: "Teach",
          collection: classes,
          icon: Icons.record_voice_over,
        );

  @override
  State<TeachScreen> createState() => _TeachScreenState();
}

class _TeachScreenState extends CollectionScreenState<TeachScreen> {
  @override
  Widget docDisplay(SQDoc doc) {
    final List<SQDoc> classRequests = requests.filter([
      DocRefFilter(
          docRefField: (requests.getFieldByName("Requested Class")
              as SQDocReferenceField)
            ..value = SQDocReference.fromDoc(doc))
    ]);

    // print(classRequests);
    print("Class: " + doc.identifier);
    for (var classRequest in classRequests) {
      print(classRequest.identifier);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(doc.identifier),
            Text((doc.getFieldValueByName("Class Type") as SQDocReference)
                .docIdentifier),
            DocEditScreen(doc).button(context, label: "Edit Class"),
            Text(classRequests.length.toString() + " Students"),
          ],
        ),
      ),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        DocCreateScreen(classes).button(context),
        super.screenBody(context),
      ],
    );
  }
}
