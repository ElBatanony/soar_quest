import 'package:flutter_test/flutter_test.dart';

import 'package:soar_quest/cloud_functions/get_collections_docs.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/data/unimplemented_collection.dart';

void main() async {
  test("Getting Logs collection docs", () async {
    final logsCollection = UnimplementCollection("Logs", [
      SQDocField("logId", SQDocFieldType.string),
      SQDocField("message", SQDocFieldType.string),
      SQDocField("date", SQDocFieldType.timestamp),
      SQDocField("payload", SQDocFieldType.bool),
    ]);
    const collectionId = "sample-apps/Tech Admin/Logs";

    GetCollectionDocs cf = GetCollectionDocs(logsCollection);
    List<SQDoc> yo = await cf.getDocs(collectionId);
    print(yo[0].getFieldValueByName("logId"));
  });
}
