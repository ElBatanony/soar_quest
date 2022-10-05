import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db/sq_doc.dart';
import 'firebase_file_storage.dart';
import 'sq_file_storage.dart';
import '../ui/sq_button.dart';
import '../db/fields/sq_bool_field.dart';

class SQFileField extends SQBoolField {
  late SQFileStorage storage;

  bool get fileExists => value;

  SQFileField(super.name, {super.value, SQFileStorage? storage}) {
    this.storage = storage ?? FirebaseFileStorage();
  }

  @override
  SQFileField copy() {
    return SQFileField(name, value: value, storage: storage);
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return SQFileFormField(this, onChanged: onChanged, doc: doc);
  }
}

class SQFileFormField<FileField extends SQFileField>
    extends DocFormField<FileField> {
  const SQFileFormField(super.field,
      {super.key, super.onChanged, required super.doc});

  @override
  createState() => SQFileFormFieldState<FileField>();
}

class SQFileFormFieldState<FileField extends SQFileField>
    extends DocFormFieldState<FileField> {
  String? downloadUrl;

  getDownloadUrl() async {
    downloadUrl = await field.storage.getFileDownloadURL(doc!, field);
    setState(() {});
  }

  openFileUrl() async {
    if (downloadUrl == null) throw "Download URL for ${field.name} is null";
    if (!await launchUrl(Uri.parse(downloadUrl!),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $downloadUrl';
    }
  }

  selectAndUploadFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await field.storage.uploadFile(
          doc: doc!,
          file: pickedFile,
          field: field,
          onUpload: () {
            getDownloadUrl();
            onChanged();
          });
    }
  }

  deleteFile() async {
    await field.storage.deleteFile(doc: doc!, field: field);
    onChanged();
  }

  @override
  void initState() {
    if (field.fileExists) getDownloadUrl();
    super.initState();
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        field.fileExists
            ? (downloadUrl != null
                ? SQButton("Download", onPressed: openFileUrl)
                : Text("Loading file"))
            : Text("File not set"),
        SQButton("${field.fileExists ? 'Edit' : 'Upload'} File",
            onPressed: selectAndUploadFile),
        if (field.fileExists)
          IconButton(onPressed: deleteFile, icon: Icon(Icons.delete))
      ],
    );
  }
}
