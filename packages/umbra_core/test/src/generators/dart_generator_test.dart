// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('DartGenerator', () {
    test('generate a Dart Shader file', () async {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );
      final generator = DartGenerator(specification);

      simpleShader.toDart(cwd).writeAsBytesSync(await generator.generate());

      expect(
        await generator.generate(),
        matchesFixture(simpleShader.toDart(cwd)),
      );
    });

    test('generate a Dart Shader file with uniforms correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_uniforms',
        withUniformsShader.input,
      );
      final generator = DartGenerator(specification);

      withUniformsShader
          .toDart(cwd)
          .writeAsBytesSync(await generator.generate());

      expect(
        await generator.generate(),
        matchesFixture(withUniformsShader.toDart(cwd)),
      );
    });
  });
}
