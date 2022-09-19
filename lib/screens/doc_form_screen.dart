List<DocFormField> generateDocFieldsFields(
  SQDoc doc, {
  List<String> hiddenFields = const [],
  List<String>? shownFields,
}) {
  // TODO: required fields (validate not null)
  List<SQDocField> fields = doc.fields;

  if (shownFields != null)
    fields = fields
        .where((field) => shownFields.contains(field.name) == true)
        .toList();

  fields = fields
      .where((field) => hiddenFields.contains(field.name) == false)
      .toList();

  return fields
      .map((field) => DocFormField(
            field,
            doc: doc,
          ))
      .toList();
}
