import '../data.dart';

class UnimplementCollection extends SQCollection {
  UnimplementCollection(super.id, super.fields);

  @override
  Future createDoc(SQDoc doc) {
    throw UnimplementedError();
  }

  @override
  Future deleteDoc(String docId) {
    throw UnimplementedError();
  }

  @override
  Future<bool> doesDocExist(String docId) {
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
  Future updateDoc(SQDoc doc) {
    throw UnimplementedError();
  }
}
