import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/data_object.dart';
import 'package:soar_quest/data_ui/data_object_display.dart';
import 'package:soar_quest/screens/screen.dart';

class DataDisplayScreen extends Screen {
  final DataObject object;
  const DataDisplayScreen(String title, this.object, {Key? key})
      : super(title, key: key);

  @override
  State<DataDisplayScreen> createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  void loadData() async {
    await widget.object.loadData();
    setState(() {});
  }

  void deleteDoc() {
    db.doc(widget.object.dataPath).delete().then((value) {
      widget.object.collection!.loadCollection();
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
            Text('Object path: ${widget.object.dataPath}'),
            DataObjectDisplay(widget.object),
            ElevatedButton(onPressed: deleteDoc, child: Text("Delete Item"))
          ],
        ),
      ),
    );
  }
}
