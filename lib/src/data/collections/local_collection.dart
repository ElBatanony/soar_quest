import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../sq_collection.dart';

export '../sq_collection.dart';

class LocalCollection extends SQCollection {
  LocalCollection({
    required super.id,
    required super.fields,
    super.parentDoc,
    super.updates,
    super.actions,
  });

  static SharedPreferences? _prefs;

  Future<void> _initPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> loadCollection() async {
    await _initPrefs();
    final prefsStrings = _prefs!.getStringList(path) ?? [];
    docs = prefsStrings.map((e) {
      final docObject = jsonDecode(e);
      if (docObject is! Map<String, dynamic>)
        throw Exception('Error loading local collection doc');
      final newDocId = docObject['id'] as String?;
      final newDocData = docObject['data'] as Map<String, dynamic>?;
      if (newDocId == null) throw Exception('Doc ID is null');
      if (newDocData == null) throw Exception('Doc data is null');
      return newDoc(id: newDocId)..parse(newDocData);
    }).toList();
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
