import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../mini_apps.dart';
import '../data/sq_field.dart';
import '../screens/screen.dart';
import '../ui/button.dart';

const defaultDeltaJson = [
  {'insert': '\n'}
];

class SQTextDocField extends SQField<Document> {
  SQTextDocField(super.name);

  @override
  Document? parse(source) {
    if (source is String) {
      final json = jsonDecode(source);
      if (json is List<dynamic>) return Document.fromJson(json);
    }
    return super.parse(source);
  }

  @override
  serialize(value) {
    if (value == null) return null;
    return jsonEncode(value.toDelta().toJson());
  }

  @override
  formField(docScreen) => SQTextDocFormField(this, docScreen);

  @override
  String toString() => 'Text Doc $name';
}

class SQTextDocFormField extends SQFormField<Document, SQTextDocField> {
  SQTextDocFormField(super.field, super.docScreen);

  late final QuillController _controller = QuillController(
      document: getDocValue() ?? Document.fromJson(defaultDeltaJson),
      selection: const TextSelection.collapsed(offset: 0));

  @override
  Widget readOnlyBuilder(context) => SizedBox(
        height: 40,
        child: QuillEditor.basic(
          controller: _controller,
          readOnly: true,
          autoFocus: false,
        ),
      );

  @override
  Widget fieldBuilder(context) => Column(
        children: [
          readOnlyBuilder(context),
          SQButton(
            'Edit Text Doc',
            onPressed: () async {
              await TextDocScreen(formField: this).go<List<dynamic>>(context);
            },
          ),
        ],
      );
}

class TextDocScreen extends Screen {
  TextDocScreen({
    required this.formField,
  }) : super(formField.field.name);

  final SQTextDocFormField formField;

  late final QuillController _controller = QuillController(
      document: formField.getDocValue() ?? Document.fromJson(defaultDeltaJson),
      selection: const TextSelection.collapsed(offset: 0));

  void saveAndExit() {
    formField.setDocValue(
        Document.fromJson(_controller.document.toDelta().toJson()));
    exitScreen();
  }

  @override
  List<Widget> appBarActions() => [
        IconButton(onPressed: saveAndExit, icon: const Icon(Icons.save)),
        ...super.appBarActions()
      ];

  @override
  Widget screenBody() => Column(
        children: [
          if (formField.field.editable)
            QuillToolbar.basic(controller: _controller),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: !formField.field.editable,
            ),
          ),
        ],
      );

  @override
  void refreshMainButton() {
    MiniApp.mainButton.setParams(text: 'Save', isVisible: true);
    MiniApp.mainButton.callback = saveAndExit;
  }
}
