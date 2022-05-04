import 'dart:io';

import 'package:test/test.dart';

import 'helpers.dart';

Matcher matchesShaderFile(Directory cwd, ShaderFixture fixture) {
  return equals(fixture.outputFile(cwd).readAsStringSync());
}
