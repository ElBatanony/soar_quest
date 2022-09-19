import 'package:flutter/material.dart';

import '../../components/buttons/sq_button.dart';

import '../../data/db.dart';
import '../collection_screen.dart';

class SelectDocScreen extends CollectionScreen {
  SelectDocScreen({super.title, required super.collection, super.key});

  @override
  State<SelectDocScreen> createState() => _SelectDocScreenState();
}

class _SelectDocScreenState extends CollectionScreenState<SelectDocScreen> {
  @override
  Widget build(BuildContext context) {
    var itemsDisplay = widget.collection.docs
        .map((doc) => SQButton(doc.identifier, onPressed: () {
              Navigator.pop<SQDoc>(context, doc);
            }))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title} ${widget.collection.id}"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: itemsDisplay,
            ),
          ),
        ));
  }
}
