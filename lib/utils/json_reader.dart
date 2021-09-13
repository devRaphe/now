import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> jsonReader(String name, Duration delay) async {
  return jsonRawReader(name, delay).then((jsonStr) => jsonDecode(jsonStr));
}

Future<String> jsonRawReader(String name, [Duration delay = Duration.zero]) async {
  await Future<void>.delayed(delay);
  return rootBundle.loadString("assets/json/$name.json");
}
