import 'package:flutter/material.dart';

import '../../../db.dart';
import '../collection_screen.dart';

class CollectionFilterScreen extends CollectionScreen {
  final List<CollectionFilter> filters;

  CollectionFilterScreen({
    super.title,
    required super.collection,
    required this.filters,
    super.docScreen,
    super.prebody,
    super.postbody,
    super.icon,
    super.key,
  });

  @override
  State<CollectionFilterScreen> createState() => CollectionFilterScreenState();
}

class CollectionFilterScreenState<T extends CollectionFilterScreen>
    extends CollectionScreenState<T> {
  List<SQDoc> filteredDocs = [];

  @override
  Future<void> loadData() async {
    await super.loadData();
    updateDocs();
  }

  void updateDocs() {
    filteredDocs = widget.collection.filterBy(widget.filters);
    setState(() {});
  }

  @override
  List<Widget> docsDisplay(BuildContext context) {
    return filteredDocs.map((doc) => docDisplay(doc, context)).toList();
  }

  @override
  Widget screenBody(BuildContext context) {
    List<CollectionFieldFilter> fieldFilters =
        widget.filters.whereType<CollectionFieldFilter>().toList();

    return Column(children: [
      ...fieldFilters
          .map((fieldFilter) =>
              fieldFilter.field.formField(onChanged: (_) => updateDocs()))
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
              super.screenBody(context),
            ],
          ),
        ),
      )
    ]);
  }
}
