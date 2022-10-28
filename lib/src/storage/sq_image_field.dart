import 'package:flutter/material.dart';

import '../db/sq_doc.dart';
import 'sq_file_field.dart';

class SQImageField extends SQFileField {
  SQImageField(super.name, {super.value, super.storage});

  @override
  SQImageField copy() {
    return SQImageField(name, value: value, storage: storage);
  }

  @override
  formField({Function? onChanged, required SQDoc doc}) {
    return _SQImageFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQImageFormField extends SQFileFormField<SQImageField> {
  const _SQImageFormField(super.field, {super.onChanged, required super.doc});

  @override
  createState() => _SQImageFormFieldState();
}

class _SQImageFormFieldState extends SQFileFormFieldState<SQImageField> {
  @override
  Widget readOnlyBuilder(BuildContext context) {
    if (field.fileExists == false) return Text("No Image");
    return Image.network(field.downloadUrl!);
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    if (field.fileExists == false)
      return GestureDetector(
        onTap: selectAndUploadFile,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3)),
            height: 70,
            width: double.infinity,
            child: Icon(Icons.camera_alt, size: 40)),
      );

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.camera_alt, size: 30),
            if (field.downloadUrl != null) Image.network(field.downloadUrl!),
            TextButton.icon(
                onPressed: deleteFile,
                icon: Icon(Icons.clear),
                label: Text("Clear"))
          ],
        ));
  }
}
