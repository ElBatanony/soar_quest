import 'package:flutter/material.dart';

import '../../../db.dart';
import '../../ui/sq_button.dart';
import '../collection_screen.dart';
import '../form_screen.dart';

class CollectionFilterScreen extends CollectionScreen {
  final List<CollectionFilter> filters;

  CollectionFilterScreen({
    super.title,
    required super.collection,
    required this.filters,
    super.docScreen,
    super.icon,
    super.key,
  });

  @override
  State<CollectionFilterScreen> createState() => CollectionFilterScreenState();
}

class CollectionFilterScreenState<T extends CollectionFilterScreen>
    extends CollectionScreenState<T> {
  @override
  List<SQDoc> get docs => collection.filterBy(fieldFilters);

  late FormScreen fieldsFormScreen;
  List<CollectionFieldFilter> fieldFilters = [];

  @override
  void initState() {
    fieldFilters = widget.filters.whereType<CollectionFieldFilter>().toList();

    SQCollection fakeColl = InMemoryCollection(
        id: "hi",
        fields: fieldFilters.map((fieldFilter) => fieldFilter.field).toList());

    SQDoc fakeDoc = fakeColl.newDoc();
    for (final fieldFilter in fieldFilters) {
      fieldFilter.field = fakeDoc.getField(fieldFilter.field.name)!;
    }

    fieldsFormScreen = FormScreen(fakeDoc, isInline: true);

    super.initState();
  }

  Widget filterFieldsDisplay() {
    return Column(
      children: [
        fieldsFormScreen,
        Text('Total docs: ${widget.collection.docs.length}'),
        Text('Showing docs: ${docs.length}')
      ],
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        filterFieldsDisplay(),
        SQButton("Filter", onPressed: () => refreshScreen()),
        Expanded(child: super.screenBody(context)),
      ],
    );
  }
}
