import 'sq_collection.dart';

class UnimplementCollection extends SQCollection {
  UnimplementCollection({required super.id, required super.fields});

  @override
  Future deleteDoc(SQDoc doc) {
    throw UnimplementedError();
  }

  @override
  String getANewDocId() {
    throw UnimplementedError();
  }

  @override
  Future loadCollection() => super.loadCollection();

  @override
  Future<SQDoc> loadDoc(SQDoc doc) {
    throw UnimplementedError();
  }

  @override
  Future saveDoc(SQDoc doc) {
    throw UnimplementedError();
  }
}
