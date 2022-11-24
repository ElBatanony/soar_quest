import 'package:flutter/material.dart';

import '../../data/collections/in_memory_collection.dart';
import '../collection_screen.dart';
import '../form_screen.dart';

class CollectionFilterScreen extends CollectionScreen {
  final List<CollectionFilter> filters;
  final List<CollectionFieldFilter> fieldFilters = [];

  CollectionFilterScreen({
    super.title,
    required super.collection,
    required this.filters,
    super.icon,
  });

  @override
  State<CollectionFilterScreen> createState() => CollectionFilterScreenState();

  List<SQDoc> filterDocs(
      List<SQDoc> initialDocs, List<CollectionFilter> filters) {
    return filters.fold(
        initialDocs, (remainingDocs, filter) => filter.filter(remainingDocs));
  }

  @override
  List<SQDoc> get docs => filterDocs(collection.docs, fieldFilters);

  Widget filterFieldsDisplay(ScreenState screenState) {
    fieldFilters.clear();
    fieldFilters
        .addAll((screenState as CollectionFilterScreenState).fieldFilters);
    return Column(
      children: [
        screenState.fieldsFormScreen,
        Text('Total docs: ${collection.docs.length}'),
        Text('Showing docs: ${docs.length}')
      ],
    );
  }

  @override
  Widget screenBody(ScreenState screenState) {
    return Column(
      children: [
        filterFieldsDisplay(screenState),
        Expanded(child: super.screenBody(screenState)),
      ],
    );
  }
}

class CollectionFilterScreenState<T extends CollectionFilterScreen>
    extends CollectionScreenState<T> {
  late FormScreen fieldsFormScreen;
  List<CollectionFieldFilter> fieldFilters = [];

  @override
  void initState() {
    fieldFilters = widget.filters.whereType<CollectionFieldFilter>().toList();

    SQCollection fakeColl = InMemoryCollection(
        id: "hi",
        fields: fieldFilters.map((fieldFilter) => fieldFilter.field).toList());

    SQDoc fakeDoc = fakeColl.newDoc();

    fieldsFormScreen =
        FormScreen(fakeDoc, isInline: true, onFieldsChanged: (doc) {
      for (final fieldFilter in fieldFilters) {
        fieldFilter.field = doc.getField(fieldFilter.field.name)!;
      }
      refreshScreen();
    });

    super.initState();
  }
}
