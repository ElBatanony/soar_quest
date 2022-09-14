import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/components/doc_field_field.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocCreateScreen extends Screen {
  final SQCollection collection;
  final Function? createCallback;
  final List<SQDocField> initialFields;
  final List<String> hiddenFields;

  const DocCreateScreen(String title, this.collection,
      {this.createCallback,
      this.initialFields = const [],
      this.hiddenFields = const [],
      Key? key})
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
    newDoc = SQDoc(newDocId, collection: widget.collection);

    for (var field in widget.initialFields) {
      newDoc.getFieldByName(field.name).value = field.value;
    }

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
                createCallback: widget.createCallback,
                hiddenFields: widget.hiddenFields,
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
  // final List<DocFieldField> objectFieldsFields;
  final Function? createCallback;
  final List<String> hiddenFields;

  const DocCreateScreenBody(this.doc,
      {this.createCallback, required this.hiddenFields, super.key});

  @override
  Widget build(BuildContext context) {
    void saveItem() async {
      doc.collection.createDoc(doc).then((value) {
        if (createCallback != null) createCallback!();
        exitScreen(context);
      });
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Doc ID (generated)"), Text(doc.id)],
          ),
          ...DocFieldField.generateDocFieldsFields(doc,
              hiddenFields: hiddenFields),
          ElevatedButton(onPressed: saveItem, child: Text("Save / Insert"))
        ]),
      ),
    );
  }
}
