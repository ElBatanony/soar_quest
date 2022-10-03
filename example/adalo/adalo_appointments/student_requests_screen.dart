import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_appointments.dart';

class StudentsRequestsScreen extends DocScreen {
  final SQDoc classDoc;

  StudentsRequestsScreen(this.classDoc, {super.key}) : super(classDoc);

  @override
  State<StudentsRequestsScreen> createState() => _StudentsRequestsScreenState();
}

class _StudentsRequestsScreenState
    extends DocScreenState<StudentsRequestsScreen> {
  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        NewRequestsScreen(classDoc: widget.classDoc),
        RescheduledRequestsScreen(classDoc: widget.classDoc),
        BookedRequestsScreen(classDoc: widget.classDoc),
      ],
    );
  }
}

class NewRequestsScreen extends CollectionScreen {
  final SQDoc classDoc;

  NewRequestsScreen({required this.classDoc, super.key})
      : super(
            title: "New Requests",
            collection: requests,
            isInline: true,
            docScreen: (doc) => NewRequestTeacherScreen(doc));

  @override
  State<NewRequestsScreen> createState() => _NewRequestsScreenState();
}

class _NewRequestsScreenState extends CollectionScreenState<NewRequestsScreen> {
  @override
  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection
        .filter([
          DocRefFilter("Requested Class", SQDocRef.fromDoc(widget.classDoc)),
          ValueFilter("Status", "Pending")
        ])
        .map((doc) => docDisplay(doc))
        .toList();
  }
}

class BookedRequestsScreen extends CollectionScreen {
  final SQDoc classDoc;

  BookedRequestsScreen({required this.classDoc, super.key})
      : super(
            title: "Booked",
            collection: requests,
            isInline: true,
            docScreen: (doc) => NewRequestTeacherScreen(doc));

  @override
  State<BookedRequestsScreen> createState() => _BookedRequestsScreenState();
}

class _BookedRequestsScreenState
    extends CollectionScreenState<BookedRequestsScreen> {
  @override
  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection
        .filter([
          DocRefFilter("Requested Class", SQDocRef.fromDoc(widget.classDoc)),
          ValueFilter("Status", "Booked")
        ])
        .map((doc) => docDisplay(doc))
        .toList();
  }
}

class NewRequestTeacherScreen extends DocScreen {
  NewRequestTeacherScreen(super.doc, {super.key})
      : super(canDelete: false, canEdit: false);

  @override
  State<NewRequestTeacherScreen> createState() =>
      _NewRequestTeacherScreenState();
}

class _NewRequestTeacherScreenState
    extends DocScreenState<NewRequestTeacherScreen> {
  void rescheduleRequest() async {
    bool rescheduledRequest = await goToScreen(
        docEditScreen(
          doc,
          shownFields: ["Reschedule Comment", "Requested Class Date", "Time"],
        ),
        context: context);

    if (rescheduledRequest) {
      doc.setDocFieldByName("Status", "Rescheduled");
      await doc.updateDoc().then((_) => exitScreen(context));
    }
  }

  void bookRequest() async {
    bool bookedRequest = await goToScreen(
        docEditScreen(
          doc,
          shownFields: ["Video Meeting Link"],
        ),
        context: context);

    if (bookedRequest) {
      doc.setDocFieldByName("Status", "Booked");
      await doc.updateDoc().then((_) => exitScreen(context));
    }
  }

  @override
  Widget screenBody(BuildContext context) {
    String status = widget.doc.value("Status");
    return Column(
      children: [
        super.screenBody(context),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SQButton("Reschedule", onPressed: rescheduleRequest),
            if (status != "Booked") SQButton("Book", onPressed: bookRequest),
          ],
        ),
      ],
    );
  }
}

class RescheduledRequestsScreen extends CollectionScreen {
  final SQDoc classDoc;

  RescheduledRequestsScreen({required this.classDoc, super.key})
      : super(
          title: "Rescheduled",
          collection: requests,
          isInline: true,
          docScreen: (doc) => DocScreen(
            doc,
            canDelete: false,
            canEdit: false,
          ),
        );

  @override
  State<RescheduledRequestsScreen> createState() =>
      _RescheduledRequestsScreenState();
}

class _RescheduledRequestsScreenState
    extends CollectionScreenState<RescheduledRequestsScreen> {
  @override
  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection
        .filter([
          DocRefFilter("Requested Class", SQDocRef.fromDoc(widget.classDoc)),
          ValueFilter("Status", "Rescheduled")
        ])
        .map((doc) => docDisplay(doc))
        .toList();
  }
}
