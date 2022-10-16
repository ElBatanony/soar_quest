import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'sq_collection.dart';

class LocalCollection extends SQCollection {
  static SharedPreferences? _prefs;

  LocalCollection({
    required super.id,
    required super.fields,
    String? singleDocName,
    super.parentDoc,
    super.readOnly,
    super.canDeleteDoc,
    super.docScreen,
    super.actions,
  });

  Future<void> _initPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> loadCollection() async {
    await _initPrefs();
    List<String> prefsStrings = _prefs!.getStringList(path) ?? [];
    docs = prefsStrings.map((e) {
      final docObject = jsonDecode(e);
      String? newDocId = docObject['id'] as String?;
      Map<String, dynamic>? newDocData =
          docObject['data'] as Map<String, dynamic>?;
      if (newDocId == null) throw "Doc ID is null";
      if (newDocData == null) throw "Doc data is null";
      return constructDoc(newDocId)..parse(newDocData);
    }).toList();
    initialized = true;
  }

  @override
  Future<void> saveCollection() async {
    await _initPrefs();
    await _prefs!.setStringList(
        path,
        docs
            .map((d) => jsonEncode({'id': d.id, 'data': d.serialize()}))
            .toList());
  }
}
