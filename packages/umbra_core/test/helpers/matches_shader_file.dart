import 'dart:io';

import 'package:test/test.dart';

Matcher matchesShaderFile(Object key, {int? version}) {
  final String expectedShader;
  if (key is Uri) {
    expectedShader = File.fromUri(key).readAsStringSync();
  } else if (key is String) {
    expectedShader = File.fromUri(Uri.parse(key)).readAsStringSync();
  } else {
    throw ArgumentError('Unexpected type for shader file: ${key.runtimeType}');
  }
  return equals(expectedShader);
}
