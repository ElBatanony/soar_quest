import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/data_object.dart';

class DataFieldInsertDisplay extends StatefulWidget {
  final DataField field;
  const DataFieldInsertDisplay(this.field, {Key? key}) : super(key: key);

  @override
  State<DataFieldInsertDisplay> createState() => _DataFieldInsertDisplayState();
}

class _DataFieldInsertDisplayState extends State<DataFieldInsertDisplay> {
  final fieldTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.field.type == DataFieldType.int) {
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

class DataObjectInsertDisplay extends StatelessWidget {
  final DataObject object;

  DataObjectInsertDisplay(this.object, {Key? key}) : super(key: key);

  final idTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final objectFieldsFields =
        object.fields.map((field) => DataFieldInsertDisplay(field)).toList();

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
