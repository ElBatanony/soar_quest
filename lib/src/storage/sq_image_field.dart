import 'package:flutter/material.dart';

import '../data/sq_doc.dart';
import 'sq_file_field.dart';

class SQImageField extends SQFileField {
  SQImageField(super.name, {super.value, super.storage});

  @override
  SQImageField copy() {
    return SQImageField(name, value: value, storage: storage);
  }

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) {
    return _SQImageFormField(this, doc, onChanged: onChanged);
  }
}

class _SQImageFormField extends SQFileFormField<SQImageField> {
  const _SQImageFormField(super.field, super.doc, {super.onChanged});

  @override
  createState() => _SQImageFormFieldState();
}

class _SQImageFormFieldState extends SQFileFormFieldState<SQImageField> {
  @override
  Widget readOnlyBuilder(ScreenState screenState) {
    if (field.fileExists == false) return const Text('No Image');
    return Image.network(field.downloadUrl!);
  }

  @override
  Widget fieldBuilder(ScreenState screenState) {
    if (field.fileExists == false)
      return GestureDetector(
        onTap: selectAndUploadFile,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3)),
            height: 70,
            width: double.infinity,
            child: const Icon(Icons.camera_alt, size: 40)),
      );

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.camera_alt, size: 30),
            if (field.downloadUrl != null) Image.network(field.downloadUrl!),
            TextButton.icon(
                onPressed: deleteFile,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'))
          ],
        ));
  }
}
