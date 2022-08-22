import 'package:flutter/material.dart';
import 'package:soar_quest/components/doc_field_field.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'collection_screen.dart';

class CollectionFilterScreen extends CollectionScreen {
  final List<DocsFilter> filters;

  CollectionFilterScreen(String title,
      {required SQCollection collection, required this.filters, Key? key})
      : super(title, collection, key: key);

  @override
  State<CollectionFilterScreen> createState() => _CollectionFilterScreenState();
}

class _CollectionFilterScreenState extends State<CollectionFilterScreen> {
  List<SQDoc> filteredDocs = [];

  void loadData() async {
    await widget.collection.loadCollection();
    refreshScreen();
    updateDocs();
  }

  void refreshScreen() {
    setState(() {});
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  void updateDocs() {
    filteredDocs = widget.collection.filter(widget.filters);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var itemsDisplay = filteredDocs
        .map((doc) =>
            CollectionScreenDocButton(doc, widget.collection, refreshScreen))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title} ${widget.collection.id}"),
        ),
        body: Column(
          children: [
            ...widget.filters
                .map((filter) => DocFieldField(
                      filter.field,
                      onChanged: (value) => updateDocs(),
                    ))
                .toList(),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total docs: ${widget.collection.docs.length}',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Showing docs: ${filteredDocs.length}',
                      textAlign: TextAlign.center,
                    ),
                    ...itemsDisplay,
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
