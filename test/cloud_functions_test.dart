import 'package:flutter_test/flutter_test.dart';

import 'package:soar_quest/cloud_functions/get_collections_docs.dart';
import 'package:soar_quest/data/db.dart';

void main() async {
  test("Getting Logs collection docs", () async {
    final logsCollection = UnimplementCollection("Logs", [
      SQStringField("logId"),
      SQStringField("message"),
      SQTimestampField("date"),
      SQBoolField("payload"),
    ]);
    const collectionPath = "sample-apps/Tech Admin/Logs";

    GetCollectionDocs cf = GetCollectionDocs(logsCollection);
    List<SQDoc> docs = await cf.getDocs(collectionPath: collectionPath);
    print(docs[0].value("logId"));
  });
}
