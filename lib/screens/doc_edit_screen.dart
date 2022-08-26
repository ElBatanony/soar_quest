import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/components/doc_field_field.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocEditScreen extends Screen {
  final SQDoc doc;
  DocEditScreen(String title, this.doc, {Key? key}) : super(title, key: key);

  @override
  State<DocEditScreen> createState() => _DocEditScreenState();
}

class _DocEditScreenState extends State<DocEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.title} Screen',
              ),
              Text('Doc path: ${widget.doc.collection.getPath()}'),
              DocEditScreenBody(widget.doc)
            ],
          ),
        ),
      ),
    );
  }
}

class DocEditScreenBody extends StatelessWidget {
  final SQDoc doc;
  final Function? updateCallback;

  const DocEditScreenBody(this.doc, {this.updateCallback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void updateItem() async {
      await doc.collection.updateDoc(doc).then((_) {
        if (updateCallback != null)
          updateCallback!();
        else
          exitScreen(context);
      });
    }

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 350),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Doc ID"), Text(doc.id)],
            ),
            ...DocFieldField.generateDocFieldsFields(doc),
            ElevatedButton(onPressed: updateItem, child: Text("Save / Update"))
          ]),
        ),
      ),
    );
  }
}
