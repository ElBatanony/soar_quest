import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;
  final Function refreshCollectionScreen;

  DocScreen(String title, this.doc,
      {required this.refreshCollectionScreen, Key? key})
      : super(title, key: key);

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  void loadData() async {
    await widget.doc.loadData();
    setState(() {});
  }

  void deleteDoc() {
    widget.doc.collection.deleteDoc(widget.doc.id).then((_) {
      widget.refreshCollectionScreen();
      Navigator.pop(context);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.identifier),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text(
              'Object path: ${widget.doc.getPath()}',
              textAlign: TextAlign.center,
            ),
            widget.doc.collection.screen!.docScreenBody(widget.doc),
            ElevatedButton(onPressed: deleteDoc, child: Text("Delete Item"))
          ],
        ),
      ),
    );
  }
}

class DocFieldDisplay extends StatelessWidget {
  final SQDocField field;
  const DocFieldDisplay(this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('${field.name}: ${field.value} , ${field.type.name}')],
    );
  }
}

class DocScreenBody extends StatefulWidget {
  final SQDoc doc;
  const DocScreenBody(this.doc, {Key? key}) : super(key: key);

  @override
  State<DocScreenBody> createState() => _DocScreenBodyState();
}

class _DocScreenBodyState extends State<DocScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.doc.fields
              .map((field) => DocFieldDisplay(field))
              .toList()),
    );
  }
}
