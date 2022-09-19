import 'package:flutter/material.dart';

import '../../cloud_functions/get_collections_docs.dart';
import '../../data/db.dart';
import '../collection_screen.dart';

class CloudFunctionDocsScreen extends CollectionScreen {
  CloudFunctionDocsScreen({super.title, required super.collection, super.key});

  @override
  State<CloudFunctionDocsScreen> createState() =>
      _CloudFunctionDocsScreenState();
}

class _CloudFunctionDocsScreenState
    extends CollectionScreenState<CloudFunctionDocsScreen> {
  List<SQDoc> fetchedDocs = [];

  fetchDocsFromCloudFunction() async {
    GetCollectionDocs cf = GetCollectionDocs(widget.collection);
    fetchedDocs = await cf.getDocs();
    setState(() {});
  }

  @override
  void initState() {
    fetchDocsFromCloudFunction();
    super.initState();
  }

  @override
  List<Widget> docsDisplay(BuildContext context) {
    return fetchedDocs.map((doc) => docDisplay(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          children: [
            Text('${widget.title} Screen'),
            ...docsDisplay(context),
          ],
        ),
      ),
    );
  }
}
