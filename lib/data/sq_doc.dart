import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/data/sq_collection.dart';

import 'sq_doc_field.dart';
export 'sq_doc_field.dart';

final db = FirebaseFirestore.instance;

class SQDoc {
  late List<SQDocField> fields;
  String id;
  late SQCollection collection;

  static List<SQDocField> copyFields(List<SQDocField> fields) {
    return fields.map((field) => field.copy()).toList();
  }

  SQDoc(this.id, List<SQDocField> newFields, {required this.collection}) {
    fields = SQDoc.copyFields(newFields);
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

  updateDoc() {
    return db.doc(getPath()).update(collectFields());
  }

  Map<String, dynamic> collectFields() {
    Map<String, dynamic> ret = {};
    for (var field in fields) {
      ret[field.name] = field.value;
    }
    return ret;
  }

  SQDocField getFieldByName(String fieldName) {
    return fields.singleWhere((field) => field.name == fieldName);
  }

  dynamic getFieldValueByName(String fieldName) {
    return getFieldByName(fieldName).value;
  }

  Future setDocFieldByName(String fieldName, dynamic value) {
    SQDocField field = getFieldByName(fieldName);
    field.value = value;
    return updateDoc();
  }

  String getPath() {
    return "${collection.getPath()}/$id";
  }

  String get identifier => fields.first.value;
}
