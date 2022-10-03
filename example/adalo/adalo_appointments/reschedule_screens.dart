import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/components/buttons/doc_delete_button.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/screens.dart';

class RescheduledRequestStudentScreen extends DocScreen {
  RescheduledRequestStudentScreen(super.doc, {super.key});

  @override
  State<RescheduledRequestStudentScreen> createState() =>
      _RescheduledRequestStudentScreenState();
}

class _RescheduledRequestStudentScreenState
    extends DocScreenState<RescheduledRequestStudentScreen> {
  void acceptDate() async {
    doc.setDocFieldByName("Status", "Booked");
    await doc.updateDoc().then((_) => exitScreen(context));
  }

  void changeDate() async {
    bool changedDate = await goToScreen(
        docEditScreen(
          doc,
          shownFields: ["Requested Class Date", "Time"],
        ),
        context: context);

    if (changedDate) {
      doc.setDocFieldByName("Status", "Pending");
      await doc.updateDoc().then((_) => exitScreen(context));
    }
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        Text("Reschedule Comment: ${doc.value("Reschedule Comment")}"),
        Text("New requested date: ${doc.value("Requested Class Date")}"),
        Text("Time: ${doc.value("Time")}"),
        Row(
          children: [
            SQButton("Accept", onPressed: acceptDate),
            SQButton("Change", onPressed: changeDate),
            DocDeleteButton(doc),
          ],
        ),
      ],
    );
  }
}
