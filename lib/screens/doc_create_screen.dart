import 'package:flutter/material.dart';
import 'package:soar_quest/components/doc_field_field.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocCreateScreen extends Screen {
  final SQCollection collection;
  DocCreateScreen(String title, this.collection, {Key? key})
      : super(title, key: key);

  @override
  State<DocCreateScreen> createState() => _DocCreateScreenState();
}

class _DocCreateScreenState extends State<DocCreateScreen> {
  late SQDoc newDoc;

  void loadData() async {
    await widget.collection.loadCollection();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    String newDocId = widget.collection.getANewDocId();
    newDoc = SQDoc(newDocId, widget.collection.fields,
        collection: widget.collection);
    super.initState();
  }

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
              Text('Doc path: ${widget.collection.getPath()}'),
              DocCreateScreenBody(
                newDoc,
                objectFieldsFields:
                    newDoc.fields.map((field) => DocFieldField(field)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DocCreateScreenBody extends StatelessWidget {
  final SQDoc doc;
  final List<DocFieldField> objectFieldsFields;

  const DocCreateScreenBody(this.doc,
      {required this.objectFieldsFields, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void saveItem() async {
      doc.collection.createDoc(doc).then((_) => Navigator.pop(context));
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Doc ID (generated)"), Text(doc.id)],
          ),
          ...objectFieldsFields,
          ElevatedButton(onPressed: saveItem, child: Text("Save / Insert"))
        ]),
      ),
    );
  }
}
