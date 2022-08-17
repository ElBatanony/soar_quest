import 'package:flutter/material.dart';
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
              DocEditScreenBody(
                widget.doc,
                objectFieldsFields: widget.doc.fields
                    .map((field) => DocFieldField(field))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DocEditScreenBody extends StatelessWidget {
  final SQDoc doc;
  final List<DocFieldField> objectFieldsFields;

  const DocEditScreenBody(this.doc,
      {required this.objectFieldsFields, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void updateItem() async {
      await doc.collection.updateDoc(doc).then((_) => Navigator.pop(context));
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Doc ID"), Text(doc.id)],
          ),
          ...objectFieldsFields,
          ElevatedButton(onPressed: updateItem, child: Text("Save / Update"))
        ]),
      ),
    );
  }
}
