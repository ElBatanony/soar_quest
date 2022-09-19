import '../data/db.dart';
import 'doc_form_screen.dart';

Future createDoc(SQDoc doc, BuildContext context) async {
}

DocFormScreen docCreateScreen(
  SQCollection collection, {
  String? title,
  List<SQDocField> initialFields = const [],
  List<String> hiddenFields = const [],
  String submitButtonText = "Create",
}) {
  title ??= "Create ${collection.singleDocName}";

  String newDocId = collection.getANewDocId();
  SQDoc newDoc = SQDoc(newDocId, collection: collection);

  for (var field in initialFields) {
    SQDocField? newDocField = newDoc.getFieldByName(field.name);
    newDocField?.value = field.value;
    newDocField?.readOnly = field.readOnly;
  }

  return DocFormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );

  // @override
  // SQButton button(BuildContext context, {String? label}) {
  //   return super.button(context,
  //       label: label ?? "Create a ${collection.singleDocName}");
  // }
}
