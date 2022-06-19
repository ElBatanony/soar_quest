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
  void loadData() async {
    await widget.collection.loadCollection();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var docRef = widget.collection.getANewDocRef();
    String newDocId = widget.collection.getANewDocId();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text('Doc path: ${widget.collection.getPath()}'),
            DocCreateScreenBody(SQDoc(newDocId, widget.collection.fields,
                collection: widget.collection))
          ],
        ),
      ),
    );
  }
}

class DocCreateScreenBody extends StatelessWidget {
  final SQDoc doc;

  const DocCreateScreenBody(this.doc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final objectFieldsFields =
        doc.fields.map((field) => DocFieldField(field)).toList();

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
