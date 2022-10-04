import 'package:flutter/material.dart';
import 'package:soar_quest/src/screens/form_screens/doc_create_screen.dart';

import '../ui/sq_button.dart';

import '../../db.dart';
import 'doc_screen.dart';
import 'screen.dart';

export 'collection_screens/category_select_screen.dart';
export 'collection_screens/collection_filter_screen.dart';
export 'collection_screens/select_doc_screen.dart';

DocScreen defaultDocScreen(SQDoc doc) => DocScreen(doc);

typedef DocScreenBuilder = DocScreen Function(SQDoc doc);

class CollectionScreen extends Screen {
  final SQCollection collection;
  final DocScreenBuilder docScreen;
  final bool canCreate;
  final List<CollectionFilter> filters;

  CollectionScreen(
      {String? title,
      required this.collection,
      DocScreenBuilder? docScreen,
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
    return SQButton(
      doc.identifier,
      onPressed: () => goToDocScreen(docScreen(doc)),
    );
  }

  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection
        .filter(widget.filters)
        .map((doc) => docDisplay(doc))
        .toList();
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...docsDisplay(context),
            if (widget.collection.readOnly == false && widget.canCreate)
              SQButton(
                "Create ${widget.collection.singleDocName}",
                onPressed: () async {
                  await goToScreen(docCreateScreen(widget.collection),
                      context: context);
                  loadData();
                },
              ),
          ],
        ),
      ),
    );
  }
}
