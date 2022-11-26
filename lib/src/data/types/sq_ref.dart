import 'package:flutter/material.dart';

import '../sq_collection.dart';

@immutable
class SQRef {
  const SQRef({
    required this.collectionPath,
    required this.docId,
    required this.label,
  });

  SQRef.fromDoc(SQDoc doc)
      : this(
            collectionPath: doc.collection.path,
            docId: doc.id,
            label: doc.label);

  final String docId;
  final String label;
  final String collectionPath;

  @override
  String toString() => label;

  static SQRef? parse(Map<String, dynamic> source) {
    final docId = source['docId'] as String?;
    final collectionPath = source['collectionPath'] as String?;
    final label = source['label'] as String?;

    if (docId == null || collectionPath == null || label == null) return null;

    return SQRef(
      docId: docId,
      label: label,
      collectionPath: collectionPath,
    );
  }

  SQDoc get doc {
    final collection = SQCollection.byPath(collectionPath);
    if (collection == null)
      throw Exception('Referencing a non-existing collection');
    final doc = collection.getDoc(docId);
    if (doc == null) throw Exception('Referencing a non-existing doc');
    return doc;
  }

  @override
  bool operator ==(Object other) {
    if (other is! SQRef) return false;
    return other.docId == docId && other.collectionPath == collectionPath;
  }

  @override
  int get hashCode => docId.hashCode ^ collectionPath.hashCode;
}
