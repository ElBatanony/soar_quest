import 'package:flutter/material.dart';

import 'sq_file_field.dart';

class SQImageField extends SQFileField {
  SQImageField(super.name, {super.defaultValue, super.storage});

  @override
  SQImageField copy() => SQImageField(name, value: value, storage: storage);

  @override
  formField(docScreenState) => _SQImageFormField(this, docScreenState);
}

class _SQImageFormField extends SQFileFormField<SQImageField> {
  const _SQImageFormField(super.field, super.docScreenState);

  @override
  Widget readOnlyBuilder(context) {
    if (field.fileExists == false) return const Text('No Image');
    return Image.network(field.downloadUrl!);
  }

  @override
  Widget fieldBuilder(context) {
    if (field.fileExists == false)
      return GestureDetector(
        onTap: () async => selectAndUploadFile(context),
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
                onPressed: () async => deleteFile(context),
                icon: const Icon(Icons.clear),
                label: const Text('Clear'))
          ],
        ));
  }
}
