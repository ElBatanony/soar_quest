import 'package:flutter/material.dart';

import '../../db.dart';
import 'doc_screen.dart';
import 'screen.dart';
import 'form_screens/doc_create_screen.dart';

DocScreen defaultDocScreen(SQDoc doc) => DocScreen(doc);

typedef DocScreenBuilder = DocScreen Function(SQDoc doc);
typedef DocDisplayBuilder = Widget Function(SQDoc doc, CollectionScreenState s);

class CollectionScreen extends Screen {
  final SQCollection collection;
  final DocScreenBuilder docScreen;
  final bool canCreate;
  final List<CollectionFilter> filters;
  final DocDisplayBuilder? docDisplay;

  CollectionScreen(
      {String? title,
      required this.collection,
      DocScreenBuilder? docScreen,
      this.docDisplay,
      super.prebody,
      super.postbody,
      this.canCreate = false,
      super.isInline,
      super.icon,
      this.filters = const [],
      super.key})
      : docScreen = docScreen ?? collection.docScreen,
        super(title ?? collection.id);

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  Future loadData() async {
    await widget.collection.loadCollection();
    refreshScreen();
    return;
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future goToDocScreen(DocScreen docScreen) async {
    await goToScreen(docScreen, context: context);
    refreshScreen();
  }

  DocScreen docScreen(SQDoc doc) => widget.docScreen(doc);

  Widget docDisplay(SQDoc doc) {
    if (widget.docDisplay != null) return widget.docDisplay!(doc, this);
    return ListTile(
      title: Text(doc.label),
      onTap: () => goToDocScreen(docScreen(doc)),
    );
  }

  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection
        .filterBy(widget.filters)
        .map((doc) => docDisplay(doc))
        .toList();
  }

  Future createNewDoc() async {
    await goToScreen(docCreateScreen(widget.collection), context: context);
    loadData();
  }

  @override
  FloatingActionButton? floatingActionButton() {
    if (widget.canCreate)
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
