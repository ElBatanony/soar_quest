import '../data.dart';

class SQDocReference {
  SQDoc? doc;
  SQCollection collection;

  SQDocReference({required this.collection, this.doc});

  @override
  String toString() {
    return "${collection.id}/${doc?.identifier ?? "null"}";
  }
}
