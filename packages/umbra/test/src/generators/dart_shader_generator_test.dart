// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

import '../../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('DartShaderGenerator', () {
    test('generate a Dart Shader file', () async {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );
      final generator = DartShaderGenerator(
        specification,
        spirvBytes: [1, 2, 3],
      );

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
      final generator = DartShaderGenerator(
        specification,
        spirvBytes: [1, 2, 3],
      );

      expect(
        await generator.generate(),
        matchesFixture(withUniformsShader.toDart(cwd)),
      );
    });
  });
}
