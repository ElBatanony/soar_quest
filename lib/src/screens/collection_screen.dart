import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../db.dart';
import 'doc_screen.dart';
import 'form_screen.dart';
import 'screen.dart';

DocScreen defaultDocScreen(SQDoc doc) => DocScreen(doc);

typedef DocScreenBuilder = DocScreen Function(SQDoc doc);
typedef DocDisplayBuilder = Widget Function(SQDoc doc, CollectionScreenState s);

class CollectionScreen extends Screen {
  final SQCollection collection;
  final DocScreenBuilder docScreen;
  final DocDisplayBuilder? docDisplay;
  final String? groupBy;

  CollectionScreen(
      {String? title,
      required this.collection,
      DocScreenBuilder? docScreen,
      this.docDisplay,
      super.prebody,
      super.postbody,
      super.isInline,
      super.icon,
      this.groupBy,
      super.key})
      : docScreen = docScreen ?? collection.docScreen,
        super(title ?? collection.id);

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  SQCollection get collection => widget.collection;

  Future<void> loadData() async {
    await collection.loadCollection();
    refreshScreen();
    return;
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> goToDocScreen(DocScreen docScreen) async {
    await docScreen.go(context);
    refreshScreen();
  }

  DocScreen docScreen(SQDoc doc) => widget.docScreen(doc);

  Widget docDisplay(SQDoc doc, BuildContext context) {
    if (widget.docDisplay != null) return widget.docDisplay!(doc, this);
    return ListTile(
      title: Text(doc.label),
      subtitle: doc.fields.length >= 2
          ? Text((doc.fields[1].value ?? "").toString())
          : null,
      leading: doc.imageLabel != null
          ? Image.network(doc.imageLabel!.value!, width: 35)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: collection.actions
            .where((action) => action.show.check(doc, context))
            .map((action) => action.button(doc, isIcon: true))
            .toList(),
      ),
      onTap: () => goToDocScreen(docScreen(doc)),
    );
  }

  List<Widget> groupByDocs(BuildContext context) {
    Map<dynamic, List<SQDoc>> groups = groupBy<SQDoc, dynamic>(
        collection.docs, (doc) => doc.value<dynamic>(widget.groupBy!));

    return groups.entries
        .map((entry) => Column(
              children: [
                Text(entry.key.toString()),
                ...entry.value.map((doc) => docDisplay(doc, context))
              ],
            ))
        .toList();
  }

  List<Widget> docsDisplay(BuildContext context) {
    if (widget.groupBy != null) return groupByDocs(context);

    return collection.docs.map((doc) => docDisplay(doc, context)).toList();
  }

  Future<void> createNewDoc() async {
    await FormScreen(collection.newDoc()).go(context);
    loadData();
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    if (collection.adds)
      return FloatingActionButton(
          heroTag: null,
          shape: CircleBorder(),
          onPressed: createNewDoc,
          child: Icon(Icons.add));
    return null;
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView(
            shrinkWrap: true,
            children: docsDisplay(context),
          ),
        ),
      ],
    );
  }
}
