import 'sq_collection.dart';

class UnimplementCollection extends SQCollection {
  UnimplementCollection({required super.id, required super.fields});

  @override
  Future createDoc(SQDoc doc) {
    throw UnimplementedError();
  }

  @override
  Future deleteDoc(String docId) {
    throw UnimplementedError();
  }

  @override
  bool doesDocExist(String docId) {
    throw UnimplementedError();
  }

  @override
  String getANewDocId() {
    throw UnimplementedError();
  }

  @override
  String getPath() {
    throw UnimplementedError();
  }

  @override
  Future loadCollection() {
    throw UnimplementedError();
  }

  @override
  Future<SQDoc> loadDoc(SQDoc doc) {
    throw UnimplementedError();
  }

  @override
  Future saveDoc(SQDoc doc) {
    throw UnimplementedError();
  }
}
