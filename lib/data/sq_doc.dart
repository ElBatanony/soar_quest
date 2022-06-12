import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data/sq_collection.dart';

final db = FirebaseFirestore.instance;

enum SQDocFieldType { int, string }

class SQDocField {
  String name;
  SQDocFieldType type;
  // ignore: prefer_typing_uninitialized_variables
  var value;

  SQDocField(this.name, this.type, {this.value});

  static SQDocField unknownField() {
    return SQDocField("Unknown", SQDocFieldType.string);
  }
}

class SQDoc {
  List<SQDocField> fields;
  String id;
  late SQCollection collection;

  SQDoc(this.id, this.fields, {required this.collection});

  SQDoc.withData(this.id, this.fields, Map<String, dynamic> dataToSet) {
    setData(dataToSet);
  }

  setData(Map<String, dynamic> dataToSet) {
    dataToSet.forEach((key, value) {
      fields.firstWhere((element) => element.name == key, orElse: () {
        print("Data field not found");
        return SQDocField.unknownField();
      }).value = value;
    });
  }

  loadData() async {
    await db.doc(getPath()).get().then((doc) {
      print(doc.data());
      setData(doc.data()!);
    });
  }

  Map<String, dynamic> collectFields() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.value;
    }
    return ret;
  }

  SQDocField getField(String fieldName) {
    return fields.singleWhere((field) => field.name == fieldName);
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }
}
