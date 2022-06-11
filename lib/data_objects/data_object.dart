import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/apps/app.dart';
import 'package:soar_quest/data_objects/data_collection.dart';

final db = FirebaseFirestore.instance;

enum DataFieldType { int, string }

class DataField {
  String name;
  DataFieldType type;
  // ignore: prefer_typing_uninitialized_variables
  var value;

  DataField(this.name, this.type, {this.value});

  static DataField unknownField() {
    return DataField("Unknown", DataFieldType.string);
  }
}

class DataObject {
  List<DataField> fields;
  String dataPath;
  bool userData;
  String id;
  DataCollection? collection;

  DataObject(this.id, this.fields, this.dataPath,
      {this.userData = false, this.collection}) {
    if (userData)
      dataPath = App.instance.currentUser!.userDataPath() + dataPath;
  }

  DataObject.withData(
      this.id, this.fields, this.dataPath, Map<String, dynamic> dataToSet,
      {this.userData = false}) {
    setData(dataToSet);
  }

  setData(Map<String, dynamic> dataToSet) {
    dataToSet.forEach((key, value) {
      fields.firstWhere((element) => element.name == key, orElse: () {
        print("Data field not found");
        return DataField.unknownField();
      }).value = value;
    });
  }

  loadData() async {
    await db.doc(dataPath).get().then((doc) {
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
}
