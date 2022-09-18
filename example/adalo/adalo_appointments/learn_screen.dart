import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';

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