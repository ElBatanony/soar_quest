import 'package:flutter/material.dart';

import '../cloud_functions/get_collections_docs.dart';
import '../data.dart';
import 'collection_screen.dart';
import 'screen.dart';

class CloudFunctionDocsScreen extends Screen {
  final SQCollection collection;

  const CloudFunctionDocsScreen(String title,
      {required this.collection, Key? key})
      : super(title, key: key);

  @override
  State<CloudFunctionDocsScreen> createState() =>
      _CloudFunctionDocsScreenState();
}

class _CloudFunctionDocsScreenState extends State<CloudFunctionDocsScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          children: [
            Text('${widget.title} Screen'),
            ...fetchedDocs
                .map((doc) =>
                    CollectionScreenDocButton(doc, widget.collection, () {}))
                .toList()
          ],
        ),
      ),
    );
  }
}
