import 'package:flutter/material.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_appointments.dart';
import 'reschedule_screens.dart';

class LearnScreen extends CollectionScreen {
  LearnScreen({super.key})
      : super(title: "Learn", collection: requests, icon: Icons.local_library);

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
  SQDocRef? teacherDocRef;

  void loadData() async {
    requestClassDoc =
        (widget.doc.value("Requested Class") as SQDocRef).getDoc();
    await requestClassDoc!.loadDoc();
    teacherDocRef = requestClassDoc!.value("Teacher");
    setState(() {});
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String status = widget.doc.value("Status");
    return GestureDetector(
      onTap: () {
        if (status == "Rescheduled")
          goToScreen(RescheduledRequestStudentScreen(widget.doc),
              context: context);
        else
          goToScreen(
              DocScreen(
                widget.doc,
                canDelete: true,
                canEdit: false,
              ),
              context: context);
      },
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
              Text("Status: $status"),
              if (requestClassDoc?.initialized == true)
                Text("Teacher: ${teacherDocRef!.docIdentifier}"),
              Text(
                  "Requested Date: ${widget.doc.value("Requested Class Date")}"),
            ],
          ),
        ),
      ),
    );
  }
}
