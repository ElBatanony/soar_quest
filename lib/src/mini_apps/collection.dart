import '../data/sq_collection.dart';

import 'cloud_storage.dart';
import 'js.dart';
import 'mini_app.dart';

class MiniAppCollection extends SQCollection {
  MiniAppCollection({required super.id, required super.fields});

  final CloudStorage cloudStorage = MiniApp.cloudStorage;

  @override
  Future<void> loadCollection() async {
    isLoading = true;
    final serializedString = await cloudStorage.getItem<String>(id);

    docs = [];

    List<Map<String, dynamic>> docsList;
    try {
      docsList = (jsonDecode(serializedString) as List<dynamic>)
          .map((docObject) => docObject as Map<String, dynamic>)
          .toList();
    } on Exception {
      isLoading = false;
      return;
    }

    for (final docObject in docsList) {
      final newDocId = docObject['id'] as String?;
      final newDocData = docObject['data'] as Map<String, dynamic>?;
      if (newDocId == null || newDocData == null) continue;
      docs.add(newDoc(id: newDocId)..parse(newDocData));
    }
    isLoading = false;
  }

  @override
  Future<void> saveCollection() async {
    final serializedDocs =
        docs.map((doc) => {'id': doc.id, 'data': doc.serialize()}).toList();
    cloudStorage.setItem(id, jsonEncode(serializedDocs));
  }
}
