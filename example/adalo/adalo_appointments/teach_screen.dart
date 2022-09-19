import 'package:flutter/material.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_appointments.dart';
import 'student_requests_screen.dart';

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
    final List<SQDoc> classRequests = requests
        .filter([DocRefFilter("Requested Class", SQDocReference.fromDoc(doc))]);

    int numberOfRequests = classRequests.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(doc.identifier),
            Text((doc.getFieldValueByName("Class Type") as SQDocReference)
                .docIdentifier),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                docEditScreen(doc).button(context, label: "Edit Class"),
                StudentsRequestsScreen(doc)
                    .button(context, label: "$numberOfRequests Students")
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        docCreateScreen(classes).button(context),
        super.screenBody(context),
      ],
    );
  }
}
