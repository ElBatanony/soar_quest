import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocScreen extends Screen {
  final SQDoc object;
  final Function refreshCollectionScreen;
  const DocScreen(String title, this.object,
      {required this.refreshCollectionScreen, Key? key})
      : super(title, key: key);

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  void loadData() async {
    await widget.object.loadData();
    setState(() {});
  }

  void deleteDoc() {
    widget.object.collection.deleteDoc(widget.object).then((_) {
      widget.refreshCollectionScreen();
      Navigator.pop(context);
    });
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text('Object path: ${widget.object.getPath()}'),
            DocDisplay(widget.object),
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

class DocDisplay extends StatelessWidget {
  final SQDoc object;

  const DocDisplay(this.object, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: object.collection.screen?.dataObjectDisplayBody == null
          ? docDisplayBody(object)
          : object.collection.screen?.dataObjectDisplayBody!(object),
    );
  }
}

Widget docDisplayBody(SQDoc object) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: object.fields.map((field) => DocFieldDisplay(field)).toList());
}
