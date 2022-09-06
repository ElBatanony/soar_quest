import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:soar_quest/app/app.dart';

abstract class CloudFunction {
  final String name;
  final String region;
  static String projectId = 'soar-quest-test';

  Future<dynamic> call({String params = ""}) async {
    String emulatorUrl =
        'http://localhost:5001/$projectId/$region/$name?$params';
    String liveUrl =
        'https://$region-$projectId.cloudfunctions.net/$name?$params';
    String url = App.instance.emulatingCloudFunctions ? emulatorUrl : liveUrl;
    http.Response response = await http.get(
      Uri.parse(url),
    );

    dynamic json = jsonDecode(response.body);
    return json;
  }

  CloudFunction(this.name, {this.region = "us-central1"});
}
