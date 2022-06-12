import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocCreateScreen extends Screen {
  final SQCollection collection;
  const DocCreateScreen(String title, this.collection, {Key? key})
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
            Text('Object path: ${widget.collection.collectionPath}'),
            DocCreateDisplay(SQDoc("new-id", widget.collection.fields, "new-id",
                userData: widget.collection.userData,
                collection: widget.collection))
          ],
        ),
      ),
    );
  }
}

class DocFieldCreateDisplay extends StatefulWidget {
  final SQDocField field;
  const DocFieldCreateDisplay(this.field, {Key? key}) : super(key: key);

  @override
  State<DocFieldCreateDisplay> createState() => _DocFieldCreateDisplayState();
}

class _DocFieldCreateDisplayState extends State<DocFieldCreateDisplay> {
  final fieldTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.field.type == SQDocFieldType.int) {
      return TextField(
        onChanged: (intText) {
          widget.field.value = int.parse(intText);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.field.name,
        ),
      );
    }

    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        widget.field.value = text;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.field.name,
      ),
    );
  }
}

class DocCreateDisplay extends StatelessWidget {
  final SQDoc object;

  DocCreateDisplay(this.object, {Key? key}) : super(key: key);

  final idTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final objectFieldsFields =
        object.fields.map((field) => DocFieldCreateDisplay(field)).toList();

    void saveItem() async {
      db
          .doc("${object.collection!.collectionPath}/${object.id}")
          .set(object.collectFields())
          .then((value) {
        object.collection!.loadCollection();
        Navigator.pop(context);
      });
    }

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(
          controller: idTextController,
          onChanged: (newId) {
            object.id = newId;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Doc ID",
          ),
        ),
        ...objectFieldsFields,
        ElevatedButton(onPressed: saveItem, child: Text("Save / Insert"))
      ]),
    );
  }
}
