import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/fields/sq_string_field.dart';
import '../data/sq_doc.dart';
import '../ui/sq_button.dart';
import 'firebase_file_storage.dart';
import 'sq_file_storage.dart';

class SQFileField extends SQStringField {
  late SQFileStorage storage;

  bool get fileExists => value != null;

  String? get downloadUrl => value;

  SQFileField(super.name, {super.value, SQFileStorage? storage}) {
    this.storage = storage ?? FirebaseFileStorage();
  }

  @override
  SQFileField copy() {
    return SQFileField(name, value: value, storage: storage);
  }

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) {
    return SQFileFormField(this, doc, onChanged: onChanged);
  }
}

class SQFileFormField<FileField extends SQFileField>
    extends SQFormField<FileField> {
  const SQFileFormField(super.field, super.doc, {super.key, super.onChanged});

  @override
  createState() => SQFileFormFieldState<FileField>();
}

class SQFileFormFieldState<FileField extends SQFileField>
    extends SQFormFieldState<FileField> {
  Future<void> openFileUrl() async {
    if (field.downloadUrl == null)
      throw "Download URL for ${field.name} is null";
    if (!await launchUrl(Uri.parse(field.downloadUrl!),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch ${field.downloadUrl}';
    }
  }

  Future<void> selectAndUploadFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await field.storage.uploadFile(
          doc: doc,
          file: pickedFile,
          field: field,
          onUpload: () => onChanged());
    }
  }

  Future<void> deleteFile() async {
    await field.storage.deleteFile(doc: doc, field: field);
    onChanged();
  }

  @override
  Widget fieldBuilder(ScreenState screenState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        if (field.fileExists)
          SQButton("Download", onPressed: openFileUrl)
        else
          Text("File not set"),
        SQButton("${field.fileExists ? 'Edit' : 'Upload'} File",
            onPressed: selectAndUploadFile),
        if (field.fileExists)
          IconButton(onPressed: deleteFile, icon: Icon(Icons.delete))
      ],
    );
  }
}
