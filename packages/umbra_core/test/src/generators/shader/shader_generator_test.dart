// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../../../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('UmbraShaderGenerator', () {
    test('generates a simple shader', () async {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );
      final generator = ShaderGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, simpleShader),
      );
    });

    test('generates a shader with precision correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_precision',
        withPrecisionShader.input,
      );
      final generator = ShaderGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withPrecisionShader),
      );
    });

    test('generates a shader with uniforms correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_uniforms',
        withUniformsShader.input,
      );
      final generator = ShaderGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withUniformsShader),
      );
    });

    test('generates a shader with version correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_version',
        withVersionShader.input,
      );
      final generator = ShaderGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withVersionShader),
      );
    });
  });
}
